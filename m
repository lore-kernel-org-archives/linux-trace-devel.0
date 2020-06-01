Return-Path: <SRS0=rFKH=7O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BFAC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jun 2020 19:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D372076B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jun 2020 19:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="vKS4h7KE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgFAToJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 15:44:09 -0400
Received: from mail.efficios.com ([167.114.26.124]:40786 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgFAToJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 15:44:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 37F47296D5E;
        Mon,  1 Jun 2020 15:44:08 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id I18vrN0qywDw; Mon,  1 Jun 2020 15:44:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C4895296C46;
        Mon,  1 Jun 2020 15:44:07 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com C4895296C46
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1591040647;
        bh=AiN/FDxwRvncFzKs5VxJ6bC+dU3IfQzXVOT6PjWhV94=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=vKS4h7KEzcgK8/JCuj9zeYseuUoNY8UNRiwc7B15B44CniVEWeAH4fP3tDuRLyxe1
         S+LfBDQeRzLxp3xMKKEf/TGxFrVSgXmHVa7PTdXexdjfQJJrqs3u/CQ7Zh3SSxJMuG
         VAxImRFGx5WrxZskXZewy0RB8FLK6TbYPcgSztJQ50fvtx7Sy4WMjXu26tWZb0nP6f
         XPADffN8tb4qjAmLq/hyg47WzannyGGhkKxnaL6kEz94qAkXMKkvXie5xNjQrriBMT
         I5jtuv9727k0/8R619odmz/XQzzk7mTtoKjYGzkMKQTRgit4BUAefyuUA1CVQTcaL7
         rUMVI+ZrBtJDw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LArmjVej3gSC; Mon,  1 Jun 2020 15:44:07 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id B271F2970BA;
        Mon,  1 Jun 2020 15:44:07 -0400 (EDT)
Date:   Mon, 1 Jun 2020 15:44:07 -0400 (EDT)
From:   Philippe Duplessis-Guindon <pduplessis@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel <linux-trace-devel@vger.kernel.org>
Message-ID: <2031915056.45850.1591040647633.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200601143643.7f30b068@oasis.local.home>
References: <2053437111.45156.1591029910431.JavaMail.zimbra@efficios.com> <20200601143643.7f30b068@oasis.local.home>
Subject: Re: Ftrace plugin for Babeltrace2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3928 (ZimbraWebClient - FF76 (Linux)/8.8.15_GA_3928)
Thread-Topic: Ftrace plugin for Babeltrace2
Thread-Index: E1yaPbQQcJZnNq9H/gII5Aao1NIBYg==
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt" <rostedt@goodmis.org>
To: "Philippe Duplessis-Guindon" <pduplessis@efficios.com>
Cc: "linux-trace-devel" <linux-trace-devel@vger.kernel.org>
Sent: Monday, June 1, 2020 2:36:43 PM
Subject: Re: Ftrace plugin for Babeltrace2

On Mon, 1 Jun 2020 12:45:10 -0400 (EDT)
Philippe Duplessis-Guindon <pduplessis@efficios.com> wrote:

>> Hi everyone,
>> 
>> 
>> My name is Philippe and I am an intern at EfficiOs for the summer. This email is

> Hi Philippe!

> I believe we met before. Correct me if I'm wrong.

You must be mistaking me with the other Philippe at EfficiOs. I am an intern who started last month!

>> 
>> to inform you about my summer project, ask for recommendations and your opinion.
>> 
>> 
>> My project will consist of implementing a Babeltrace2 [1] plugin to be able to consume
>> 
>> ftrace traces. The plugin will act as a source component in the babeltrace2 graph system.

> This is awesome!

>> 
>> 
>> I was wondering if you can give me your first thoughts about this project, and
>> 
>> any advice on where to find information to begin with, since I am new to ftrace.
>> 
>> I have already read the doc [2][3][4], but I was wondering if there are more resources
>> 
>> that could help me with my work.
>> 
>> 
>> Also, I was wondering which version of libtraceevent I should use. The one in the kernel,
>> 
>> or the one in the trace-cmd repo? My guess would be to take the one in trace-cmd since
>> 
>> there are more recent commits, but I am asking just to make sure.

> Well it shouldn't matter, as I try to keep the two insync, but because
> of the current environment (COVID-19 and all), I've been falling behind.

Perfect!

> There's talk in moving it out of both the kernel and trace-cmd and make
> libtraceevent a stand alone library. But that will take some
> coordination.

That would be great!

>> 
>> 
>> The major focus of the project will be to match ftrace concepts to babeltrace 2
>> 
>> internal representation.
>> 
>> 
>> [1] https://babeltrace.org/
>> 
>> [2] https://github.com/torvalds/linux/tree/master/tools/lib/traceevent/Documentation
>> 
>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/tree/Documentation
>> 
>> [4] https://www.kernel.org/doc/Documentation/trace/ftrace.txt
>> 


> Ideally, we would like to get KernelShark to use babeltrace as well, to
> increase what it can read.

Sounds good, I'll have this in mind while implementing my plugin.

> Thanks for reaching out. If there's anything else you need, please feel
> free to ask.

Thank you,
Philippe
