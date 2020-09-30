Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57551C4727E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 14:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22EA1207FB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 14:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgI3ODV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730104AbgI3ODV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 10:03:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3470B20754;
        Wed, 30 Sep 2020 14:03:21 +0000 (UTC)
Date:   Wed, 30 Sep 2020 10:03:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel-shark :Fix all build warnings for gcc 10.2.1
Message-ID: <20200930100319.7c31d5d2@gandalf.local.home>
In-Reply-To: <bd59b018-df9c-fa0d-5b6a-7de2ba4c30fc@gmail.com>
References: <20200916065007.9755-1-y.karadz@gmail.com>
        <20200929170555.3f45e952@gandalf.local.home>
        <bd59b018-df9c-fa0d-5b6a-7de2ba4c30fc@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 30 Sep 2020 16:55:45 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Yes, this is wrong. Thanks a lot Steven!
> Do you prefer to re-send the entire patch-set or only this one?


Resend the entire set. It makes patchwork happier ;-)

-- Steve
