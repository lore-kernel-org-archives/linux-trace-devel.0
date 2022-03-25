Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D67C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Mar 2022 19:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiCYTtG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiCYTr4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 15:47:56 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CCA1786BA;
        Fri, 25 Mar 2022 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=KMC7/9jTpe9v+E1NnmAuNea1e+9FubhZixtwMrAgmFo=; b=J2Bts
        OklpsY1qXe5F1zD09AHVweziiqc6wqQg7z5uQOwFeNm1PDBW7fZn1SAjIRdkzXeS1Ns8ZFs+5YD34
        QPgc7V+0Wnifhg5Iv1zqEaPwOqUdchgwnfzyXEW0v8CorbbNfxQag8E9AiYky9N0jAKCPTZeJaNbo
        N4/85pmzTUbj1OFlENT7bTTGaSWhK1jv/eH8rk4X/WdT+vvRVLTYlL0cjU8skLGzt2gQezUZoy1nf
        rnpR4RaKCS1M+2ejM+D8ms3CkVAUqy7tqAsJmoJhomUYErUBAu78P2eeLDrSSI5lYjMLsHNW2RZGq
        SPSwYgpu6SSLqbK/qvlllFYSOVThw==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1nXpk8-0002S0-QJ; Fri, 25 Mar 2022 19:37:04 +0000
Date:   Fri, 25 Mar 2022 19:37:03 +0000
From:   John Keeping <john@metanate.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 06/12] trace-cmd analyze: Add tracing of tasks and their
 states
Message-ID: <Yj4Z39HsErMB73E9@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
 <20220324025726.1727204-7-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324025726.1727204-7-rostedt@goodmis.org>
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 23, 2022 at 10:57:20PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If sched_switch is found and has the prev_state field, then record them
> and keep track of the time the task was in the state, the number of times
> it was scheduled out of the state, and print the total time, average time,
> and number of times the task was scheduled out of that state. Also show
> the time stamp of where the longest time it went into that state.
> 
> Currently the only states that are supported are "preempted" (which was in
> state running), "blocked" (state uninterruptible), "sleeping" (state
> interruptible), and "other" (all other states).
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> @@ -288,6 +337,24 @@ static void process_switch(struct analysis_data *data,
>  		task->start_ts = record->ts;
>  		cpu_data->current_pid = pid;
>  
> +		switch (task->last_state) {
> +		case -1:
> +			/* First time seen */
> +			break;
> +		case 0:
> +			update_sched_timings(&task->preempt, record->ts);
> +			break;
> +		case 0x1:
> +			update_sched_timings(&task->sleep, record->ts);
> +			break;
> +		case 0x2:
> +			update_sched_timings(&task->blocked, record->ts);
> +			break;
> +		default:
> +			update_sched_timings(&task->other, record->ts);
> +		}
> +		task->last_state = val & 0x1f;

val is next_pid here, does last_state even need to be updated for the
switched-to task?
