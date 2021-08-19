Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABD6C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD6F610CE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhHSTeh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhHSTeh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:34:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 355A5610A0;
        Thu, 19 Aug 2021 19:34:00 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:33:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 87/87] trace-cmd: Document trace file version 7
Message-ID: <20210819153358.172ad728@oasis.local.home>
In-Reply-To: <20210729050959.12263-88-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-88-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

OK, so I quickly went through the rest of the series, and this really
should have been at least 4 different patch sets. This series was
really hard to review, because it bounced around between clean ups,
sections, compressions, and conversions.

Thus, I'm going to set this entire series to "Changes Requested".

Please break this into at least 4 patch sets (here's 6 I would recommend).

Patch set 1: Clean ups.

Any change that was to make v6 work better with v7, or fix to v6 or
whatever. Should be first. It should be non-controversial, and we can
get that in right away.


Patch set 2: Sections:

This adds the notion of v7, but also adds all the work that has to do
with sections. Anything that has to do with compression, should be the
"non-compressed" case. The focus of this series would be to simply
break up the file for v7 where it is grouped by sections.

Patch set 3: Compression

This is where you can add all the changes that deal with compression.


Patch set 4: Conversion

This will add all the changes that are used to convert between v6 <-> v7.

Patch set 5: Dump

The changes here would be for dumping the output.

Patch set 6: Documentation.

And finally, add all the documentation at the end.

This will make it much easier to understand, and manage. Let's not have
a 87 patch series again. It's just too big to manage.

-- Steve
