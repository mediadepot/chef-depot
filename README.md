# chef-depot-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['chef-depot']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### chef-depot::default

Include `chef-depot` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[chef-depot::default]"
  ]
}
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)




## Testing/Development
  https://github.com/rancher/rancher/issues/1920 Hairpin nat fails 
  curl --header 'Host: guacweb.depot.local' 'http://10.0.2.15:50001'