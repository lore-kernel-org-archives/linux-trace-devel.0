Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76029C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Mar 2022 15:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiCZPeP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 26 Mar 2022 11:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiCZPeO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 26 Mar 2022 11:34:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEAD1ADA0;
        Sat, 26 Mar 2022 08:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 542A2B80A37;
        Sat, 26 Mar 2022 15:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354EDC2BBE4;
        Sat, 26 Mar 2022 15:32:34 +0000 (UTC)
Date:   Sat, 26 Mar 2022 11:32:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Keeping <john@metanate.com>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 09/12] trace-cmd analyze: Add wake up latency timings
Message-ID: <20220326113232.0dbfd503@rorschach.local.home>
In-Reply-To: <Yj71frLcA+W9hkMw@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
        <20220324025726.1727204-10-rostedt@goodmis.org>
        <Yj4ZPMJdz49eQy7I@donbot>
        <20220325161333.65ffb789@gandalf.local.home>
        <20220325163148.0bf4146b@gandalf.local.home>
        <Yj71frLcA+W9hkMw@donbot>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 26 Mar 2022 11:14:06 +0000
John Keeping <john@metanate.com> wrote:

> I started having a look at whether it's possible to add an overview of
> interrupts from irq:irq_handler_entry & irq:irq_handler_exit and I guess
> that would fit in TRACECMD_ANALYZE_FL_NONE above, but it would be good
> to have per-cpu stats for irqs as well so does that mean an additional
> record type is needed?

I actually created that enum for exactly that ;-) To be able to add
different metrics in the future. Which is why it states "PID". I
actually did think about adding things like

  TRACECMD_ANALYZE_FL_IRQ

To say this is to add irq interruptions. Perhaps even add:

  TRACECMD_ANALYZE_FL_STOLEN

for guest stolen times.

I haven't decided on that API yet. Perhaps we could add new custom
timings too, and include them somehow. I have to think about a good API
to use.

-- Steve
