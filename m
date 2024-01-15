Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD7217C7B
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jan 2024 17:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC53F2F4;
	Mon, 15 Jan 2024 09:23:03 -0800 (PST)
Received: from [10.34.100.129] (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF9CE3F5A1;
	Mon, 15 Jan 2024 09:22:16 -0800 (PST)
Message-ID: <efb02cc0-65d9-4b76-9ec6-030a6f39b1c5@arm.com>
Date: Mon, 15 Jan 2024 18:22:15 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] trace-cmd: usage: Update usage for trace-cmd split
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
 <20240112083945.1361293-3-pierre.gondois@arm.com>
 <20240112103731.36beb00c@gandalf.local.home>
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240112103731.36beb00c@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Steven,

On 1/12/24 16:37, Steven Rostedt wrote:
> On Fri, 12 Jan 2024 09:39:42 +0100
> Pierre Gondois <pierre.gondois@arm.com> wrote:
> 
>> Update usage for 'trace-cmd split' command.
> 
> I mentioned in my reply to the cover letter about the subject, but also
> having more detail in the change log is good. What was missing from the
> usage that needed to be fixed?

The patch just intended to add available parameters that were missing
from the documentation.

> 
>>
>> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
>> ---
>>   tracecmd/trace-split.c | 21 +++++++++++++--------
>>   tracecmd/trace-usage.c |  3 ++-
>>   2 files changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
>> index 6ccda2fc..b6c056b5 100644
>> --- a/tracecmd/trace-split.c
>> +++ b/tracecmd/trace-split.c
>> @@ -198,7 +198,7 @@ static int parse_cpu(struct tracecmd_input *handle,
>>   		     unsigned long long start,
>>   		     unsigned long long end,
>>   		     int count_limit, int percpu, int cpu,
>> -		     enum split_types type)
>> +		     enum split_types type, bool *end_reached)
>>   {
>>   	struct tep_record *record;
>>   	struct tep_handle *pevent;
>> @@ -325,6 +325,9 @@ static int parse_cpu(struct tracecmd_input *handle,
>>   		}
>>   	}
>>   
>> +	if (record && (record->ts > end))
>> +		*end_reached = true;
>> +
>>   	if (record)
>>   		tracecmd_free_record(record);
>>   
>> @@ -352,7 +355,8 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
>>   				     unsigned long long start,
>>   				     unsigned long long end, int percpu,
>>   				     int only_cpu, int count,
>> -				     enum split_types type)
>> +				     enum split_types type,
>> +				     bool *end_reached)
>>   {
>>   	unsigned long long current;
>>   	struct tracecmd_output *ohandle;
>> @@ -396,14 +400,14 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
>>   
>>   	if (only_cpu >= 0) {
>>   		parse_cpu(handle, cpu_data, start, end, count,
>> -			  1, only_cpu, type);
>> +			  1, only_cpu, type, end_reached);
>>   	} else if (percpu) {
>>   		for (cpu = 0; cpu < cpus; cpu++)
>>   			parse_cpu(handle, cpu_data, start,
>> -				  end, count, percpu, cpu, type);
>> +				  end, count, percpu, cpu, type, end_reached);
>>   	} else
>>   		parse_cpu(handle, cpu_data, start,
>> -			  end, count, percpu, -1, type);
>> +			  end, count, percpu, -1, type, end_reached);
>>   
>>   	cpu_list = malloc(sizeof(*cpu_list) * cpus);
>>   	if (!cpu_list)
>> @@ -415,7 +419,6 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
>>   	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
>>   		die("Failed to append tracing data\n");
>>   
>> -	current = end;
>>   	for (cpu = 0; cpu < cpus; cpu++) {
>>   		/* Set the tracecmd cursor to the next set of records */
>>   		if (cpu_data[cpu].offset) {
>> @@ -440,6 +443,7 @@ void trace_split (int argc, char **argv)
>>   	struct tracecmd_input *handle;
>>   	unsigned long long start_ns = 0, end_ns = 0;
>>   	unsigned long long current;
>> +	bool end_reached = false;
>>   	double start, end;
>>   	char *endptr;
>>   	char *output = NULL;
>> @@ -564,11 +568,12 @@ void trace_split (int argc, char **argv)
>>   			strcpy(output_file, output);
>>   			
>>   		current = parse_file(handle, output_file, start_ns, end_ns,
>> -				     percpu, cpu, count, type);
>> +				     percpu, cpu, count, type, &end_reached);
>> +
>>   		if (!repeat)
>>   			break;
>>   		start_ns = 0;
>> -	} while (current && (!end_ns || current < end_ns));
>> +	} while (!end_reached && (current && (!end_ns || current < end_ns)));
>>   
>>   	free(output);
>>   	free(output_file);
> 
> The above looks like it has nothing to do with the usage, and was perhaps
> accidentally merged in this patch?

Yes right,
something wrong happened while rebasing, sorry for that...

> 
> -- Steve
> 
> 
>> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
>> index 61acce5f..433928d3 100644
>> --- a/tracecmd/trace-usage.c
>> +++ b/tracecmd/trace-usage.c
>> @@ -303,13 +303,14 @@ static struct usage_help usage_help[] = {
>>   	{
>>   		"split",
>>   		"parse a trace.dat file into smaller file(s)",
>> -		" %s split [options] -o file [start [end]]\n"
>> +		" %s split [-i file] [options] -o file [start [end]]\n"
>>   		"          -o output file to write to (file.1, file.2, etc)\n"
>>   		"          -s n  split file up by n seconds\n"
>>   		"          -m n  split file up by n milliseconds\n"
>>   		"          -u n  split file up by n microseconds\n"
>>   		"          -e n  split file up by n events\n"
>>   		"          -p n  split file up by n pages\n"
>> +		"          -C n  select CPU n\n"
>>   		"          -r    repeat from start to end\n"
>>   		"          -c    per cpu, that is -p 2 will be 2 pages for each CPU\n"
>>   		"          if option is specified, it will split the file\n"
> 
