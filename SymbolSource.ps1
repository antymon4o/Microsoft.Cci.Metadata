$version = "1.66.517.0"
echo "msbuild Build\ccimetadata.build /p:CCNetLabel=$version /p:NoWarn=""1591,0649"""
echo ".\NuGet pack SymbolSource.nuspec -version $version -symbols"
echo ".\NuGet push SymbolSource.Microsoft.Cci.Metadata.$version.nupkg"
