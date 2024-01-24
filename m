Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8951D7E78A
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706117220; cv=none; b=MM8xB3M66xc3LyiA7eLVoCnwaQ6EWIFjSCaA+tw3Jrr2cHM+VFUX5Vp1wystzPMpk+D+UBCc6oi5BWUxmxoT/NkSeQgNt79++qgZammp4jqJrOdfth6cBs32fOwCd3SeGp/2ipOjVn8M4e2hIOf0Y6B1tRbcH3ttS/I8z/MN3vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706117220; c=relaxed/simple;
	bh=5pKygqUu4tOTzjJUehGWcUNEquFBvu03HRvH6d4vPFg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ONE/bZ8DoJRWuT3sMcfiTnsG1YW0gXHcrY6D0+eDyCkOkRQ4uK+cKIYL6cT1/60dzLcj5sEACxLtvOu+r3ZaXZRfzwzJKWwGGIKui2FDtgWILFDY9mzxCFwxzRfZo98g87CdUeO5RlHiFdPwVAZjPR+pWUgY9MQOK5li18l/HE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10FFC433C7;
	Wed, 24 Jan 2024 17:26:59 +0000 (UTC)
Date: Wed, 24 Jan 2024 12:28:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] trace-cmd split: Correctly split with
 start/end/time-window parameters
Message-ID: <20240124122832.4e0b33b7@gandalf.local.home>
In-Reply-To: <20240122164336.167256-3-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
	<20240122164336.167256-3-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jan 2024 17:43:31 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

>  	if (!cpu_list)
> @@ -415,7 +419,6 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
>  	if (tracecmd_append_cpu_data(ohandle, cpus, cpu_list) < 0)
>  		die("Failed to append tracing data\n");
>  
> -	current = end;
>  	for (cpu = 0; cpu < cpus; cpu++) {
>  		/* Set the tracecmd cursor to the next set of records */
>  		if (cpu_data[cpu].offset) {

I tried running the code with valgrind, and it it went into an infinite
loop, saying that the code at line 728 had a conditional jump based on an
uninitialized variable. That line is here:

	do {
		if (repeat)
			sprintf(output_file, "%s.%04d", output, c++);
		else
			strcpy(output_file, output);
			
		current = parse_file(handle, output_file, start_ns, end_ns,
				     percpu, cpu, count, type, &end_reached);

		if (!repeat)
			break;
		start_ns = 0;
	} while (!end_reached && (current && (!end_ns || current < end_ns)));  <<<<-- Line 728

Debugging it, I found that the above "current = end;" removal removed the
only initialization of current.

Just an FYI, I'll write a fix.

Thanks,

-- Steve
