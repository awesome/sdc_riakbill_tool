# tools for sdc billing data.

## description
health checker for our sdc billingapi.

## Tested sdc
* 6.5.3

## riakbill.rb 
<pre><code># ./riakbill.rb 
Tasks:
  riakbill.rb help [TASK]                # Describe available tasks or one specific task
  riakbill.rb list                       # list all buckets
  riakbill.rb reports                    # list available reports and print index
  riakbill.rb show -n, --number=N        # show report
  riakbill.rb uuid_info -u, --uuid=UUID  # show information by uuid. configs and timestamps
</code></pre>

### list
print all backets in riak.

<pre><code># ./riakbill.rb list | head
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_timestamps
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_net0
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_timestamps
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_configs
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_configs
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_timestamps
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_configs
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_configs
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_timestamps
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_configs
</code></pre>

### reports
list availrable reports which made by billingapi.

<pre><code>./riakbill.rb reports | head
0: /usage?from=2012-08-16T15:00:00.000Z&to=2012-08-17T14:59:59.000Z
  Report Not Found.
1: /customers/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/usage?from=2012-03-12T00:00:00.000Z&to=2012-03-13T09:34:24.513Z
  in_progress? => false,  has_report? => false
2: /usage?from=2012-03-20T00:00:00.001Z&to=2012-03-22T00:00:00.000Z
  in_progress? => false,  has_report? => true
3: /usage?from=2012-07-31T15:00:00.000Z&to=2012-08-01T14:59:59.000Z
  Report Not Found.
4: /usage?from=2012-02-01T00:00:00.001Z&to=2012-02-29T00:00:00.001Z
  in_progress? => false,  has_report? => true
</code></pre>

### show
show billing report by index.

print format is yaml (json.to_yaml).

<pre><code># ./riakbill.rb show -n 2 | head
---
in_progress: false
status: 200
report:
  XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX:
    XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX:
      owner_uuid: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
      zone_uuid: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
      configuration:
        history:
-- snip --
      metering:
        network:
          net0:
            bytes_sent_delta: 126507
            period_end: '2012-03-21T07:35:00.022Z'
            period_start: '2012-03-20T00:00:00.019Z'
            bytes_received_delta: 10261915
</code></pre>


### uuid_info
print values _configs and _timestamps by zone uuid.

<pre><code># ./riakbill.rb uuid_info -u XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX | head
billing_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_configs: 1332147663199
---
-- snip --
.
.
.
</code></pre>