{
  pkgs,
  utils,
  ...
}: {
  indexBin =
    utils.writePureShellScript
    (with pkgs; [coreutils curl jq python3])
    ''
      input=''${1:?"please provide an input as a JSON file"}

      outFile=$(jq '.outputFile' -c -r $input)

      text=$(jq '.queryText' -c -r $input)
      size=$(jq '.maxPackageCount' -c -r $input)

      url="https://registry.npmjs.org/-/v1/search?text=$text&popularity=1.0&quality=0.0&maintenance=0.0&size=$size"

      curl -k "$url" | python3 ${./process-result.py} > $(realpath $outFile)
    '';
}
