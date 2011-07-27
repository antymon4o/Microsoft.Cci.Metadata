$version = "1.0.64355.5"

function Search-And-Replace ($path, $patterns) {
    Write-Output ("Replacing in {0}" -f $path)
    Get-ChildItem -Path $path -Recurse -Exclude .git -Include *.cs | ForEach-Object { 
        Write-Verbose "`t$_";
        (Get-Content $_) | ForEach-Object {
            Write-Debug "`t`t`t$_"
            $line = $_
            $patterns | ForEach-Object {
                Write-Debug ("`t`t`t`tReplacing {0} with {1} in {2}" -f $_.Key, $_.Value, $line)
                $line = $line -replace $_.Key, $_.Value
            }
            $line
        } | Set-Content $_ 
    }
    Write-Output "Done"
}

Search-And-Replace Sources @(
    @{ 
        Key   = '  (unsafe )*((private|internal|protected) )*(internal )*(((unsafe|sealed|partial|abstract|partial) )*)(class|struct|interface|enum) '
        Value = '  public $1$5$8 '
    }
    @{
        Key   = '  ((internal|protected) )(internal )*(((static|abstract|virtual|override|readonly|const) )*)(([^ :()[{=;<]+)(<[^>]+>)* )*([^ :()[{=;]+)(\(|\[|;| =| \{)'
        Value = '  public $4$7$10$11'
    }
    @{
        Key   = '  public (private|internal|protected|public) '
        Value = '  public '
    }
    @{
        Key   = '  public (return|throw) '
        Value = '  return '
    }
)

echo "msbuild Build\ccimetadata.build /p:CCNetLabel=$version"
echo ".\NuGet pack SymbolSource.nuspec -version $version -symbols"
echo ".\NuGet push SymbolSource.Microsoft.Cci.Metadata.$version.nupkg"

exit

(
    "  protected internal sealed partial class ",
    "  internal abstract partial class ",
    "  class ",
    "  unsafe internal struct "
) | ForEach-Object {
    $_ -replace '  (unsafe )*((private|internal|protected) )*(internal )*(((sealed|partial|abstract|partial) )*)(class|struct|interface|enum) ', '  public $1$5$8 ' }

exit

(
    '  internal void Seek( ',
    '  internal int abc { ',
    '  public ContractClassAttribute(int a, string b)',
    '  if (!condition) {',
    '  internal static void ReportFailure(',
    '  protected internal string this[',
    '  internal abstract virtual int ComputeHashCode();',
    '  internal Object this[int key] {',
    '  protected IEnumerable<string> Messages { get { return this.errorMessages; } }',
    '  protected List<IDisposable> disposableObjectAllocatedByThisHost = new List<IDisposable>();',
    '  internal Hashtable<object, object> DefinitionCache {',
    '  protected List<IDisposable> disposableObjectAllocatedByThisHost;'
) | ForEach-Object {
    $_ -replace '  ((internal|protected) )(internal )*(((static|abstract|virtual|override|readonly|const) )*)(([^ :()[{=;<]+)(<[^>]+>)* )*([^ :()[{=;]+)(\(|\[|;| =| \{)', '  public $4$7$10$11' }

exit

(
    '  public public ContractClassAttribute( ',
    '  public private ContractClassAttribute( '
) | ForEach-Object {
    $_ -replace '  public (private|internal|protected|public) ', '  public ' }

exit