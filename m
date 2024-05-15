Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D1F8595C;
	Wed, 15 May 2024 13:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779383; cv=none; b=LGWWHZhFwcmyf29u0TGClO3wqORRE6g+XOgdjl9BF3kL7pnMmCdkAw1rygVQsPDDr4aXMxpw4kU5wo0eo75NKjdbv0tnLTugz66W5PGtm/TSu2LALe2QiyoGfX1F3xD7MC0BVwHs37o/POT2zyCWwNngvJQC/7+Ommc7TP3wj6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779383; c=relaxed/simple;
	bh=/1ql0lp3IRfwkroLtW8SZjr/aw2tbe/M4JN2n88C0pI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gIiC3280iwrg/2QnA9FoNDv+xzp6YK2d/O6oqFWXTd6KpF4MBSSERzoGsbrRyEa3qDluoRP7U6Yo+ceV2GtoXgiULPeFOZdczYfFJCar5exGm/t8pf8KWpEiBgZ3R2ZH9hDZPAul/FaEUYUHWreBIzyWxAdMuvUCXgsPSZCtVKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOQowZM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOQowZM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE7CC32786;
	Wed, 15 May 2024 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715779383;
	bh=/1ql0lp3IRfwkroLtW8SZjr/aw2tbe/M4JN2n88C0pI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JOQowZM2zPpj5Zn+nBe6PpKs3XfOn213vnjsfOA8k6+pbFmB13d2GwzYZEEAJWK7Q
	 LKhMdC8qQVTnNZKUGm4IMb9Wb3xjcCiDVJ828aZTL/IQsfztFmvs/UsF2fKMA4Fgyh
	 C+ftkhlv6mQ/TzkbBKVcnz/30fE/EKi/CQHN9BD1ybLxZvp+R58dQqXXh9Pcv+yjoh
	 BgPy8jJ6DbUwpCs3t4556wbBcVLApNIlluoEQz8ZcpSUuhKFpfXWJbw5PzvRtiFJ01
	 QeUQYGG1zF6pm2wh8p136If85jqhGngJpqkr9RxR7MT3HdzDALCieGlhV0ferNBPCk
	 EoR4Hpf/g2flg==
Message-ID: <29f8a5ab-8b6a-4bd5-9fc3-715f8f3d3213@kernel.org>
Date: Wed, 15 May 2024 15:22:59 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] rtla: Fix -t/--trace[=file]
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, linux-trace-devel@vger.kernel.org
References: <20240510213619.53529-1-jkacur@redhat.com>
Content-Language: en-US, pt-BR, it-IT
From: Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20240510213619.53529-1-jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi John

I was applying it, and doing some small corrections in the log myself,
but I noticed some points we need to address in the code. So I am
replying also with suggestions about the log.

Nothing critical, we do need this patch :-)

On 5/10/24 23:36, John Kacur wrote:
> Normally with a short option we don't provide an equals sign like this
> -tfile.txt
> -t file.txt
> 
> But we do provide an equals sign with the long option like this
> --trace=file.txt
> 
> A good parser should also work with a space instead of an equals sign
> --trace file.txt
> 
> Most of these are broken!

While on discussions some more emphasis is required when people are
not in agreement, I'd prefer to keep the log flat on emphasis. A phrase
without the ! is better.

I generally follow script that Arnaldo once explained me:

1 - decribe the current expected beahvior.
2 - describe the issue - with a reproducer if possible (like you did).
3 - explain the solution
4 - show the expected results.

So, I would write something like this.

The -t option has an optional argument, specified after an = sign.

Ex:

  # rtla timerlat hist -u -T50 -t=file.txt

[ noticed that I removed the non-excential commands, e.g., P:95 is the default ]


Normally with a short option we don't provide an equals sign like this:
-tfile.txt -t file.txt. Moreover some other ways of using it are broken.

For example:

[ your examples ]
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
> Saving trace to ile.txt
> File name truncated
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
> Saving trace to timerlat_trace.txt
> Default file name used instead of the requested one.
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
> Saving trace to file.txt
> This works, but people normally don't use '=' with a short option
> 
> /rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
> Saving trace to ile.txt
> File name truncated
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
> timerlat_trace.txt
> Default file name used instead of the requested one.

Here you should describe the fix, i can be an simple phrase like:

Properly parse the optional argument, considering the cases with and without =.

After the fix:>
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
> Saving trace to file.txt
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
> Saving trace to file.txt
> 
> I also tested -t and --trace without providing a file name both as the
> last requested option and with a following long and short option

My personal preference is also to speak in third person, about the code, or in imperative
mode. Like:

Tested using...

> For example
For example:
> 
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t -u
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace -u
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t
> ./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace
> 
> And all correctly do Saving trace to timerlat_trace.txt as expected
> 
> This fix is applied to both timerlat top and hist
> and to osnoise top and hist
> 

To make my life easier: the changes for each version will not show up
in the final log, so it is a good practice to place them after the "---".

> Version 2
> 
> - Remove the '=' from [=file] in the on line help. Do the same thing
> for the manpages.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---

[ here you place the changes when it is a single patch, for a patch ]
[ for a patch set it is enough to keep them only at the cover ]

>  Documentation/tools/rtla/common_options.rst       |  4 ----
>  .../tools/rtla/common_osnoise_options.rst         |  5 +++++
>  .../tools/rtla/common_timerlat_options.rst        |  4 ++++
>  tools/tracing/rtla/src/osnoise_hist.c             | 15 ++++++++++-----
>  tools/tracing/rtla/src/osnoise_top.c              | 15 ++++++++++-----
>  tools/tracing/rtla/src/timerlat_hist.c            | 15 ++++++++++-----
>  tools/tracing/rtla/src/timerlat_top.c             | 15 ++++++++++-----
>  7 files changed, 49 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/tools/rtla/common_options.rst b/Documentation/tools/rtla/common_options.rst
> index aeb91ff3bd68..5d28ba61245c 100644
> --- a/Documentation/tools/rtla/common_options.rst
> +++ b/Documentation/tools/rtla/common_options.rst
> @@ -14,10 +14,6 @@
>  
>          Print debug info.
>  
> -**-t**, **--trace**\[*=file*]
> -
> -        Save the stopped trace to [*file|osnoise_trace.txt*].
> -
>  **-e**, **--event** *sys:event*
>  
>          Enable an event in the trace (**-t**) session. The argument can be a specific event, e.g., **-e** *sched:sched_switch*, or all events of a system group, e.g., **-e** *sched*. Multiple **-e** are allowed. It is only active when **-t** or **-a** are set.
> diff --git a/Documentation/tools/rtla/common_osnoise_options.rst b/Documentation/tools/rtla/common_osnoise_options.rst
> index f792ca58c211..b05eee23b539 100644
> --- a/Documentation/tools/rtla/common_osnoise_options.rst
> +++ b/Documentation/tools/rtla/common_osnoise_options.rst
> @@ -25,3 +25,8 @@
>  
>          Specify the minimum delta between two time reads to be considered noise.
>          The default threshold is *5 us*.
> +
> +**-t**, **--trace**\[*file*]
> +
> +        Save the pretty stopped trace to [*file|osnoise_trace.txt*].
> +
> diff --git a/Documentation/tools/rtla/common_timerlat_options.rst b/Documentation/tools/rtla/common_timerlat_options.rst
> index d3255ed70195..e4eca500b6a7 100644
> --- a/Documentation/tools/rtla/common_timerlat_options.rst
> +++ b/Documentation/tools/rtla/common_timerlat_options.rst
> @@ -22,6 +22,10 @@
>          Save the stack trace at the *IRQ* if a *Thread* latency is higher than the
>          argument in us.
>  
> +**-t**, **--trace**\[*file*]
> +
> +        Save the pretty stopped trace to [*file|timerlat_trace.txt*].
> +
>  **--dma-latency** *us*
>          Set the /dev/cpu_dma_latency to *us*, aiming to bound exit from idle latencies.
>          *cyclictest* sets this value to *0* by default, use **--dma-latency** *0* to have
> diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
> index 01870d50942a..ede8bb44919c 100644
> --- a/tools/tracing/rtla/src/osnoise_hist.c
> +++ b/tools/tracing/rtla/src/osnoise_hist.c
> @@ -436,7 +436,7 @@ static void osnoise_hist_usage(char *usage)
>  	static const char * const msg[] = {
>  		"",
>  		"  usage: rtla osnoise hist [-h] [-D] [-d s] [-a us] [-p us] [-r us] [-s us] [-S us] \\",
> -		"	  [-T us] [-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
> +		"	  [-T us] [-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
>  		"	  [-c cpu-list] [-H cpu-list] [-P priority] [-b N] [-E N] [--no-header] [--no-summary] \\",
>  		"	  [--no-index] [--with-zeros] [-C[=cgroup_name]]",
>  		"",
> @@ -452,7 +452,7 @@ static void osnoise_hist_usage(char *usage)
>  		"	  -C/--cgroup[=cgroup_name]: set cgroup, if no cgroup_name is passed, the rtla's cgroup will be inherited",
>  		"	  -d/--duration time[s|m|h|d]: duration of the session",
>  		"	  -D/--debug: print debug info",
> -		"	  -t/--trace[=file]: save the stopped trace to [file|osnoise_trace.txt]",
> +		"	  -t/--trace[file]: save the stopped trace to [file|osnoise_trace.txt]",
>  		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
>  		"	     --filter <filter>: enable a trace event filter to the previous -e event",
>  		"	     --trigger <trigger>: enable a trace event trigger to the previous -e event",
> @@ -640,9 +640,14 @@ static struct osnoise_hist_params
>  			params->threshold = get_llong_from_str(optarg);
>  			break;
>  		case 't':
> -			if (optarg)
> -				/* skip = */
> -				params->trace_output = &optarg[1];
> +			if (optarg) {
> +				if (optarg[0] == '=')
> +					params->trace_output = &optarg[1];
> +				else
> +					params->trace_output = &optarg[0];
> +			}
> +			else if (optind < argc && argv[optind][0] != '0')
> +				params->trace_output = argv[optind];


checkpatch complained about these:
	}
	else

i.e.,

  ERROR: else should follow close brace '}'
  #231: FILE: tools/tracing/rtla/src/osnoise_hist.c:649:
  +			}
  +			else if (optind < argc && argv[optind][0] != '0')


it should be:
  +			} else if (optind < argc && argv[optind][0] != '0')

Finally, rebase it on top of:

https://git.kernel.org/pub/scm/linux/kernel/git/bristot/linux.git/log/?h=devel/rtla-for-6.10

Thanks!
-- Daniel
