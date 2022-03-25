Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E914EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Mar 2022 19:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiCYTts (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiCYTs0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 15:48:26 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AC925FD63;
        Fri, 25 Mar 2022 12:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=aQv+M74UdWvhgAeKlBIGuP0FoleXDAN0eAEXDeiMwbs=; b=t+nRu
        8aYMv4CI0mwEfSscGM3pFLsMJ0iz7yCZ/WwXweDtai0ngHeIOKWYcl7r5B1IvaP0XGMQw8hBiBaLU
        nMwsHbavm8g9WDD9hlUfTfoHAVH/n0GbwPX9ll5u+ofMjQJ36JjJakZwNkUdsan62MwIHfLKkDGb4
        wOewQC2cVa/hyCLt+XlbcDvSgZWEO/T4fN079A3Kv+FO9kMqil1YsQYw7isxN7OHwCFPMd0zBg2HA
        OYYeDaXW+R+oVho1mQFFALVpd37HSu7h98F6pSibm/8b8jgz2EZ75dcwyIxg4NqrQRmPBDFomvrmp
        LOz3aeRjD5m/mKUjfQnf0dn4kWiLg==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1nXpjV-0002RD-Bk; Fri, 25 Mar 2022 19:36:25 +0000
Date:   Fri, 25 Mar 2022 19:36:24 +0000
From:   John Keeping <john@metanate.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 03/12] trace-cmd analyze: Show how much tasks run on each
 CPU
Message-ID: <Yj4ZuJxzT1oV8zhh@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
 <20220324025726.1727204-4-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324025726.1727204-4-rostedt@goodmis.org>
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 23, 2022 at 10:57:17PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Display for each CPU that was traced, the amount of time tasks ran on
> them. Listing the tasks from the longest runner to the least.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> +	for (i = 0; i < nr_tasks; i++) {
> +		task = cpu_tasks[i]->task;
> +
> +		if (!i) {
> +			printf("    Task name        PID \t     Run time\n");
> +			printf("    ---------        --- \t     --------\n");
> +		}
> +		printf("%16s %8d\t",
> +		       tep_data_comm_from_pid(tep, task->pid),
> +		       task->pid);
> +		print_time(cpu_tasks[i]->runtime, '_');
> +		printf(" (%%%lld)\n", (task->runtime * 100) / total_time);

Is there a reason for using the CPU-specific runtime for the value and
the total runtime for the percentage?

I expected the percentage to be the percentage of this CPU's time spend
running the task.
