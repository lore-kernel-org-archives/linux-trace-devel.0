Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8DC1D53F
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 15:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D003C433C7;
	Fri, 12 Jan 2024 15:36:26 +0000 (UTC)
Date: Fri, 12 Jan 2024 10:37:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/5] trace-cmd: usage: Update usage for trace-cmd split
Message-ID: <20240112103731.36beb00c@gandalf.local.home>
In-Reply-To: <20240112083945.1361293-3-pierre.gondois@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
	<20240112083945.1361293-3-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jan 2024 09:39:42 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> Update usage for 'trace-cmd split' command.

I mentioned in my reply to the cover letter about the subject, but also
having more detail in the change log is good. What was missing from the
usage that needed to be fixed?

> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
>  tracecmd/trace-split.c | 21 +++++++++++++--------
>  tracecmd/trace-usage.c |  3 ++-
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
> index 6ccda2fc..b6c056b5 100644
> --- a/tracecmd/trace-split.c
> +++ b/tracecmd/trace-split.c
> @@ -198,7 +198,7 @@ static int parse_cpu(struct tracecmd_input *handle,
>  		     unsigned long long start,
>  		     unsigned long long end,
>  		     int count_limit, int percpu, int cpu,
> -		     enum split_types type)
> +		     enum split_types type, bool *end_reached)
>  {
>  	struct tep_record *record;
>  	struct tep_handle *pevent;
> @@ -325,6 +325,9 @@ static int parse_cpu(struct tracecmd_input *handle,
>  		}
>  	}
>  
> +	if (record && (record->ts > end))
> +		*end_reached = true;
> +
>  	if (record)
>  		tracecmd_free_record(record);
>  
> @@ -352,7 +355,8 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
>  				     unsigned long long start,
>  				     unsigned long long end, int percpu,
>  				     int only_cpu, int count,
> -				     enum split_types type)
> +				     enum split_types type,
> +				     bool *end_reached)
>  {
>  	unsigned long long current;
>  	struct tracecmd_output *ohandle;
> @@ -396,14 +400,14 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
>  
>  	if (only_cpu >= 0) {
>  		parse_cpu(handle, cpu_data, start, end, count,
> -			  1, only_cpu, type);
> +			  1, only_cpu, type, end_reached);
>  	} else if (percpu) {
>  		for (cpu = 0; cpu < cpus; cpu++)
>  			parse_cpu(handle, cpu_data, start,
> -				  end, count, percpu, cpu, type);
> +				  end, count, percpu, cpu, type, end_reached);
>  	} else
>  		parse_cpu(handle, cpu_data, start,
> -			  end, count, percpu, -1, type);
> +			  end, count, percpu, -1, type, end_reached);
>  
>  	cpu_list = malloc(sizeof(*cpu_list) * cpus);
>  	if (!cpu_list)
> @@ -415,7 +419,6 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
>  	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
>  		die("Failed to append tracing data\n");
>  
> -	current = end;
>  	for (cpu = 0; cpu < cpus; cpu++) {
>  		/* Set the tracecmd cursor to the next set of records */
>  		if (cpu_data[cpu].offset) {
> @@ -440,6 +443,7 @@ void trace_split (int argc, char **argv)
>  	struct tracecmd_input *handle;
>  	unsigned long long start_ns = 0, end_ns = 0;
>  	unsigned long long current;
> +	bool end_reached = false;
>  	double start, end;
>  	char *endptr;
>  	char *output = NULL;
> @@ -564,11 +568,12 @@ void trace_split (int argc, char **argv)
>  			strcpy(output_file, output);
>  			
>  		current = parse_file(handle, output_file, start_ns, end_ns,
> -				     percpu, cpu, count, type);
> +				     percpu, cpu, count, type, &end_reached);
> +
>  		if (!repeat)
>  			break;
>  		start_ns = 0;
> -	} while (current && (!end_ns || current < end_ns));
> +	} while (!end_reached && (current && (!end_ns || current < end_ns)));
>  
>  	free(output);
>  	free(output_file);

The above looks like it has nothing to do with the usage, and was perhaps
accidentally merged in this patch?

-- Steve


> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 61acce5f..433928d3 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -303,13 +303,14 @@ static struct usage_help usage_help[] = {
>  	{
>  		"split",
>  		"parse a trace.dat file into smaller file(s)",
> -		" %s split [options] -o file [start [end]]\n"
> +		" %s split [-i file] [options] -o file [start [end]]\n"
>  		"          -o output file to write to (file.1, file.2, etc)\n"
>  		"          -s n  split file up by n seconds\n"
>  		"          -m n  split file up by n milliseconds\n"
>  		"          -u n  split file up by n microseconds\n"
>  		"          -e n  split file up by n events\n"
>  		"          -p n  split file up by n pages\n"
> +		"          -C n  select CPU n\n"
>  		"          -r    repeat from start to end\n"
>  		"          -c    per cpu, that is -p 2 will be 2 pages for each CPU\n"
>  		"          if option is specified, it will split the file\n"

