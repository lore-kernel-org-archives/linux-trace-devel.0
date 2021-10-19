Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62094C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 19:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470666137D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 19:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbhJSTUx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 15:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhJSTUx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 15:20:53 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CE0C061746;
        Tue, 19 Oct 2021 12:18:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 6BCD297D;
        Tue, 19 Oct 2021 19:18:39 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6BCD297D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1634671119; bh=z7ldVbQnsWAW8Gf9GiVNdED1fjhjWDpnGSCtCasTfCQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=eAeQI5bFW2K4zUVa0zD89H/SOlLVtv/+NBCoyOjfx9KaQuMDvl0b3NUv9vr4j4R6O
         3jR2afECnmqfHLlQJVRC6PGz/P8SlXPG6BevKQXYBYER6j0Oph9XGqlZEdx7CK8XW1
         A/v62ai9qxoho0O9nhD0FFnqEvfqZPm4dEIakDE8/kTzi/L9STjd32LcqPAQNCtn+j
         R2Fw7HVZc5OL9OKNdELehDXd3zkFug5lbtTrzxLmsOGpuECsuqBbK3SpeHtFY0vBaD
         0UG7vGHS+cRvxM8juvFmL4BTRJyLm2Aef/I3RMNtXlRvB23kLh9LwHJdF6Am4eeeTX
         S+q8GY0CTRUXA==
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
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH V3 13/19] rtla: Add Documentation
In-Reply-To: <5796a3d5-ae98-9d28-138f-981a06dab34b@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
 <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
 <877deaut3b.fsf@meer.lwn.net>
 <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
 <20211019092124.6b403ca4@gandalf.local.home>
 <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
 <8735oxt4ny.fsf@meer.lwn.net> <20211019113618.02bcdf8b@gandalf.local.home>
 <5796a3d5-ae98-9d28-138f-981a06dab34b@kernel.org>
Date:   Tue, 19 Oct 2021 13:18:38 -0600
Message-ID: <87tuhcsu0h.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Daniel Bristot de Oliveira <bristot@kernel.org> writes:

> Sounds good to me... actually, not only to me, but for all tools on tools I guess.
>
> Should I start with Documentation/tools/rtla/${rtla_files}.rst?

Sounds good to me.

Thanks,

jon
