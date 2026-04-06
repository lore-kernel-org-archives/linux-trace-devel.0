Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46DE27E056
	for <linux-trace-devel@vger.kernel.org>; Mon,  6 Apr 2026 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775493305; cv=none; b=ox/Cqk/77AEDjIs4Ni8cAY0x6cW20u4JwodncBJ4VXP042XG+7H0fmgJELc58VLgUYFHdnWT2S27EU3kew1/z8og6L5S55kN6PEMq17mOiKLZg66lpRXgEUkq17ip/8/Co0Y5u+xQg4xdDu3x+ZtpVXFbmrSJA2Gde1TLNxqPY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775493305; c=relaxed/simple;
	bh=MI9to5A4JwB1baNQX4T2oBDtRy13cW4HBJtsMlqKdD4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzMxC0ep95ve6BDN+bRLKp7MIYvcwTbFAuHYtATloOfTLFPyjZJw5W7Q6lic46SLAivjlQ1jfL1++sRts4J9B+q1ajfHuy8frth2s59ejEVFStayXJYYV6GPOV12g3lhvc7g6vcYuxw9eOmwo7p9UvLgRdrQPOKaaehBlA7jXsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7B5A8BD87;
	Mon,  6 Apr 2026 16:35:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 27BA820027;
	Mon,  6 Apr 2026 16:35:02 +0000 (UTC)
Date: Mon, 6 Apr 2026 12:36:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: CaoRuichuang <create0818@163.com>
Cc: linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH] trace-cmd report: add spacing before raw data flags
Message-ID: <20260406123613.764acd10@gandalf.local.home>
In-Reply-To: <20260406153221.33256-1-create0818@163.com>
References: <20260406153221.33256-1-create0818@163.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o5fq83pbsjn5j3wcpdtn7ezfkan659t4
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 27BA820027
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18Jr8hzDfpW7oJIBqd3Shrpo8NAkqVoM0M=
X-HE-Tag: 1775493302-282025
X-HE-Meta: U2FsdGVkX1/UzgL653FMsoW5Ibc5lEZTUNGuOvaUGdzecxEHH+vRuqBSKe+6qUlyn/fDfGQluzE/g6xrIaaGAZldJtGVJGY9fdrLjhTNkzi3/Qtuxou97XOOpplf8/1QlFhPKpWM/7GLOwEhBozC3ejOvd0B2JYL6eurXPjwjW5BtTMsognRbB79sl9YUAoBxlggEuhskwuaWbOUlTUm0WtmiDbifRJIrV8yZKzJCEtXqCv60okMzObd/Zjt35Ga+o+EJ6kPYh5esSVjFSwenjJmWK0JKYquMGZOOhdlY8ZY8Ht5G3Ee4UysGnvx4+BibFvtOy1ssDl91t7Q20dld/xH4hEyREE3


Hi!

Thanks for all the updates. I really do appreciate it. But some notes about
patches.

The subjects follow the Linux kernel tracing subsystem approach of starting
with a capital letter:

  trace-cmd report: Add spacing before raw data flags


On Mon,  6 Apr 2026 23:32:21 +0800
CaoRuichuang <create0818@163.com> wrote:

BTW, is CaoRuichuang your official name? As in one word. The DCO requires
real names, so I have to ask.

Also, even for small changes like this, please add content in the change
log body. The subject is about what is being done, but the change log body
is "why" it is being done. Here you explain "why" spacing is added before
raw data flags.

Thanks!

-- Steve


> Signed-off-by: CaoRuichuang <create0818@163.com>
> ---
>  tracecmd/trace-read.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index 355ee0f4..962ebd89 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -871,7 +871,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
>  			TEP_PRINT_CPU);
>  
>  	if (raw_format)
> -		trace_seq_printf(&s, "-0x%x",
> +		trace_seq_printf(&s, " -0x%x",
>  				 tep_data_flags(pevent, record));
>  	else
>  		tep_print_event(pevent, &s, record,

