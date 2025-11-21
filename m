Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C1B2EB873
	for <linux-trace-devel@vger.kernel.org>; Fri, 21 Nov 2025 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744454; cv=none; b=K/+91rIlnWg4pCgsKOkn1NKwMH01gPmcoW/NY1dPg3yZ1rJz8IiZiS5Xfmq6xDt1e7OJ40Uj27bBBNaHMEU2PD02z4LeEL+fPkJDpXdKIcb+IC0iy16YWuceU7dtdmwalGge5t9kdAmZYmirY0GoxUuNLA4p8/oPlGyWE9cZDw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744454; c=relaxed/simple;
	bh=m4HXUOcZ+rSKgDt8XF57X821Xzl3foVnAEW70vIDw8g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUltBZELRhdCJC/zahSsEesQjl4QCKhlSSHEiNjlw3F7wC5SxS52wECU0tYrXqRJ4VheDE4078qS23xk1B/FX4Rn8lUIny+6kr4HQ+MXxQ57I8tfzGrO3z1bYBMqfxyb7EnsfwHOxikZvcJQRgEuSYmh7BgurzuWxuT5aqw9unM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB45C4EFEA;
	Fri, 21 Nov 2025 17:00:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 2712C20025;
	Fri, 21 Nov 2025 17:00:43 +0000 (UTC)
Date: Fri, 21 Nov 2025 12:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] libtracecmd: fix memory leak on partial reverse
 iteration
Message-ID: <20251121120117.20e82d9e@gandalf.local.home>
In-Reply-To: <20251121134749.1530855-1-felix.moessbauer@siemens.com>
References: <20251121134749.1530855-1-felix.moessbauer@siemens.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i61yh1r4dhh87huziof1knoiwizzawfg
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 2712C20025
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Pq+iPRQBzJQLVDIMeTTJiczCYP6GY6K0=
X-HE-Tag: 1763744443-294743
X-HE-Meta: U2FsdGVkX1+4Rk+i9tnO7Vtl9H8E1iq85o6zD5j1gBhdWG7r/nDkV4g5foxo2iqejEIShZbkhX/C3MUHGuAiqJdUZ5ZP7yEwEfGXU+GNUdpyWU/kZ7oUaHih4O336iLNsY8bSjL7dNfGL0DqK+K8DAqYyHRM9mdpaxMvkgT6PP8s3YEnF//pO2wKv0MTSHueddFkMAP1BTIHOQeffKIUADhCVC58543xwaPbbKq0YhcPzDsX5aA3mZ1TMCjX6fQFC1djSvbBk/Xs/C6boQrIpw9ZmKu+r+FWWfO2v1pqccBQFfeAD+uv4RhfHza5XsiAtGUnC02gmIe+W15SCWAHtd6G7LeRV0R10gGUYze+rVzDU6x7wPwZNg==

On Fri, 21 Nov 2025 14:47:49 +0100
Felix Moessbauer <felix.moessbauer@siemens.com> wrote:

> When calling tracecmd_iterate_events_reverse with a callback that does
> not always return 0, the trace is only partially iterated. By that, the
> non-iterated records are leaked, resulting in the error:
> 
>  1 pages still allocated on cpu <cpu>
> 
> We fix this by always iterating the remaining events on all selected
> CPUs. In the full iteration case, this stops on the first record as this
> is already zero. In the partial iteration case, all remaining records
> are freed, which is - by construction of the records list - at max a
> page size.
> 
> Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
> ---
> Note, that this bug has been reported in [1].
> 
> [1] https://lore.kernel.org/linux-trace-devel/0b4fb4b774a8754ed86a9212f0a253304a41245c.camel@siemens.com/
> 

Thanks for the report. I actually found two bugs here.

> Best regards,
> Felix Moessbauer
> Siemens AG
> 
>  lib/trace-cmd/trace-input.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index f2471c92..afdbd2aa 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -2995,6 +2995,25 @@ static struct tep_record *next_last_event(struct tracecmd_input *handle,
>  	return record;
>  }
>  
> +static void free_last_events(struct tracecmd_input *handle,
> +			     struct tep_record **last_records,
> +			     cpu_set_t *cpu_set, int cpu_size,
> +			     int cpus)
> +{
> +	struct tep_record *record;
> +	int cpu;
> +
> +	for (cpu = 0; cpu < cpus; cpu++) {
> +		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpu_set))
> +			continue;
> +
> +		do {
> +			record = next_last_event(handle, last_records, cpu);
> +			tracecmd_free_record(record);
> +		} while (record);

I just fixed it slightly different than what you proposed here. But I think
we can take your patch instead.

> +	}
> +}
> +
>  /**
>   * tracecmd_iterate_events_reverse - iterate events over a given handle backwards
>   * @handle: The handle to iterate over
> @@ -3057,6 +3076,7 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
>  		}
>  	} while (next_cpu >= 0 && ret == 0);
>  
> +	free_last_events(handle, records, cpus, cpu_size, max_cpus);
>  	free(records);
>  
>  	return ret;


The second bug I found was that calling tracecmd_iterate_events_reverse()
again after a callback returned a ret value, and this time with cont = true,
it can skip a lot of records because the cursor of the last record read is
not saved. This now makes calling this function again with cont start with
the last record that was read (the one that the caller exited from).

The below patch fixes that too:

-- Steve

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index afdbd2aa98b6..8dfeff458485 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3036,6 +3036,7 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 				    void *callback_data, bool cont)
 {
 	unsigned long long last_timestamp = 0;
+	unsigned long long page_offset = 0;
 	struct tep_record **records;
 	struct tep_record *record;
 	int next_cpu;
@@ -3072,6 +3073,8 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 			record = next_last_event(handle, records, next_cpu);;
 			ret = call_callbacks(handle, record, next_cpu,
 					     callback, callback_data);
+			if (ret)
+				page_offset = record->offset;
 			tracecmd_free_record(record);
 		}
 	} while (next_cpu >= 0 && ret == 0);
@@ -3079,6 +3082,17 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 	free_last_events(handle, records, cpus, cpu_size, max_cpus);
 	free(records);
 
+	/*
+	 * If the callback exited out early, then set the cursor back
+	 * to the location of that record so that if this gets called
+	 * again with cont = true, it will continue where it left off.
+	 */
+	if (page_offset) {
+		/* Set the record to the previous record that was read */
+		record = tracecmd_read_at(handle, page_offset - 4, NULL);
+		tracecmd_free_record(record);
+	}
+
 	return ret;
 }
 
