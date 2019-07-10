Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF5DC74A36
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 17:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A73120693
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 17:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfGJRlp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 13:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbfGJRlp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 13:41:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBBC020693;
        Wed, 10 Jul 2019 17:41:43 +0000 (UTC)
Date:   Wed, 10 Jul 2019 13:41:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Submit to the Tracing Microconference at Linux Plumbers 2019
Message-ID: <20190710134142.6aeafa38@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi folks,

There will be a Tracing microconference this year at Linux Plumbers.
Linux Plumbers (https://linuxplumbersconf.org) will be held in Lisbon,
Portugal from September 9-11. The Tracing MC will be approximately a
four hour session focused on improving the Linux tracing infrastructure.

If there's a subject you would like to discuss at this microconference,
please submit a topic and abstract here:

  https://linuxplumbersconf.org/event/4/abstracts/

Select "Submit new proposal"

Fill out the title, the content and who will be leading the session,
then select the "Tracing MC topic" track and hit "Submit". Of course
you will also need to agree to follow the anti-harassment policy.

Remember, we are looking for discussions on improving tracing within
Linux. You can have up to 5 (maybe 7) minutes of presentation to bring
the audience up to speed with the issues at hand, but then the rest of
the time will be dedicated to discussion on how to solve and/or
implement the solution.

All submissions should be in by August 2, and I will hopefully be able
to decided what to discuss by August 9.

Even if you don't submit a topic, I hope to see you there to discuss
Linux tracing at Linux Plumbers in Lisbon.

Cheers,

-- Steve
