Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED34C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 15:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 707FA61D2B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 15:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhELPi2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 11:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233940AbhELP3Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 11:29:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D08F61948;
        Wed, 12 May 2021 15:15:30 +0000 (UTC)
Date:   Wed, 12 May 2021 11:15:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jerome Marchand <jmarchan@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: trace-cmd profile is not working
Message-ID: <20210512111528.45b422f9@gandalf.local.home>
In-Reply-To: <f35477a7-c301-655e-940a-bcc6b38c44f0@redhat.com>
References: <8c1d353e-05d5-d789-00a2-de94d705950e@redhat.com>
        <20210512095541.4dcfdb4d@gandalf.local.home>
        <f35477a7-c301-655e-940a-bcc6b38c44f0@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 May 2021 16:09:01 +0200
Jerome Marchand <jmarchan@redhat.com> wrote:

> Sure thing:
> https://bugzilla.kernel.org/show_bug.cgi?id=213045

Thanks,

We are working on some other aspects now, but will try to have this fixed
before we do another release.

-- Steve
