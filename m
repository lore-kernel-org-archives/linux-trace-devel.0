Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E56AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8141061074
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhJSPas (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhJSPas (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 11:30:48 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514A9C06161C;
        Tue, 19 Oct 2021 08:28:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 7C1A097D;
        Tue, 19 Oct 2021 15:28:34 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 7C1A097D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1634657314; bh=ob6CUlBFyN+fzij40nmL/LuQFz6yWVFN1ovtE7pr174=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pNTqLoMnrRE/WYhQomSXzypqMiz2oE5Fj0Ws2SIdtvr9qd/YoDycUPANxggDaZUfx
         TWMgZzXtd5zWOuIy3+O4uCtICv/4TWONPIpfqPPhaPBbZ6H942A2CPvcQ10m7EKGi2
         Zv88n2795z7rYZEFMY6wLf3oFtHqXSZeJyAE8cOwZ8iEqE+Q8hDx0yCnhqDVnK2IJs
         yvXbRy3OLQ29JJLHg5AsvIPv8HWHmJPptozLAX0cxhCkYDNZtUAr0dkN5aPorJ91vV
         g8GeWFs6/Y02aOawFrGlVi901Q5N+CpQLgxrt0lKM+yMjnLQgxq3Eki+7cjO9FyjpG
         ezuGwz/GRPKJA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 13/19] rtla: Add Documentation
In-Reply-To: <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
 <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
 <877deaut3b.fsf@meer.lwn.net>
 <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
 <20211019092124.6b403ca4@gandalf.local.home>
 <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
Date:   Tue, 19 Oct 2021 09:28:33 -0600
Message-ID: <8735oxt4ny.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Daniel Bristot de Oliveira <bristot@kernel.org> writes:

> On 10/19/21 15:21, Steven Rostedt wrote:
>> My suggestion came from not knowing that the man pages were going to live
>> in the kernel Documentation tree ;-)
>
> That is true!
>
> Question, should we mode these files to Documentation/trace/ ?

Hmm...we don't really have man pages for individual commands now, so
haven't thought much about how to handle them.

My first reaction would be to make a new directory like
Documentation/tools and put man pages there.  That can become a new
"book" within the larger documentation collection.  Make sense?

Thanks,

jon
