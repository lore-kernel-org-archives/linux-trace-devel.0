Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39144C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Mar 2022 19:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiCYTvE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiCYTu4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 15:50:56 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4E7258479;
        Fri, 25 Mar 2022 12:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=ZcsL5RPK2Rg1ueNj1ptKIwsdRaPDzfp7XVFN5wDqQuY=; b=PvHyi
        iYmGK2+5DXtNgbYmpImfJkOvt0v143agjM8KEz0aTDtgfumgijZ7arEj4CA1WZqQXksngxshTiwBv
        KuG2Gj414BnT5Y1yFeOuwOojUzCGlkokY5ZwdDXDrEX4dDawZDXF+3JAVDCXWokA0xSL2IfTjK7jn
        xK61x4SD41W+OPd3AIrltyx7j0EhCQus7Dnhh6VaRePOyRV7MH6zJtW43AYYEUkH3+PFuEkN6p5wR
        3zIPHcxt7+cGaGjHbwm62ZdvWGJoKwQHHR4Y45DX1yT/veSd7wgljwzf20f6pFpY9FUmSevf+NhTz
        KoDRMWHSZTA1452Ar566qMOIbcwtA==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1nXpha-0002Ny-Qv; Fri, 25 Mar 2022 19:34:26 +0000
Date:   Fri, 25 Mar 2022 19:34:20 +0000
From:   John Keeping <john@metanate.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 09/12] trace-cmd analyze: Add wake up latency timings
Message-ID: <Yj4ZPMJdz49eQy7I@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
 <20220324025726.1727204-10-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324025726.1727204-10-rostedt@goodmis.org>
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 23, 2022 at 10:57:23PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If the sched_waking (or sched_wakeup) event is found, then use it to time
> the wake up latency for each task.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> +static void process_wakeup(struct analysis_data *data,
> +			   struct tep_handle *tep,
> +			   struct tep_record *record)
> +{
> +	struct cpu_data *cpu_data = &data->cpu_data[record->cpu];
> +	struct task_cpu_item *cpu_task;
> +	struct task_item *task;
> +	unsigned long long val;
> +	int pid;
> +
> +	tep_read_number_field(data->wakeup_pid, record->data, &val);
> +	pid = val;
> +	cpu_task = get_cpu_task(cpu_data, pid);

Should this use get_task() instead of get_cpu_task()?

I was trying this out and it provides a great overview of a trace but I
found it strange that tasks affine to CPU N were also appearing in the
list for CPU M.

> +	task = cpu_task->task;
> +	task->wakeup.last = record->ts;
> +	task->woken = true;
> +}
