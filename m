Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9198AC433E5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 15:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B8922507
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 15:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgGNPxQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgGNPxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 11:53:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D7E2222E;
        Tue, 14 Jul 2020 15:53:15 +0000 (UTC)
Date:   Tue, 14 Jul 2020 11:53:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: Re: [PATCH 1/8] trace-cmd: Document tep_load_plugins_hook()
Message-ID: <20200714115313.4c4235c0@oasis.local.home>
In-Reply-To: <CAPpZLN7yn9b-ukjP=wD0EWzMc0rAc6mDCx_Asj=AYj3i2Opyig@mail.gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
        <20200714103027.2477584-2-tz.stoyanov@gmail.com>
        <20200714102813.2d9434d6@oasis.local.home>
        <CAPpZLN7yn9b-ukjP=wD0EWzMc0rAc6mDCx_Asj=AYj3i2Opyig@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Jul 2020 18:22:32 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > We should probably have a man page as well.  
> I'm planning to add a man page when backporting these patches from
> trace-cmd to kernel repo, as there are no libtraceevent man pages in
> trace-cmd, they exist only in the kernel tree.

Good point!

Yeah, we'll add a man page when these patches go to the kernel.

Thanks Tzvetomir!

-- Steve
