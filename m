Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F2BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CB9C6054E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 19:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhG2TTD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 15:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhG2TTD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 15:19:03 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4129B60462;
        Thu, 29 Jul 2021 19:18:59 +0000 (UTC)
Date:   Thu, 29 Jul 2021 15:18:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/3] libtracefs documentation fixes
Message-ID: <20210729151852.4b59afb9@oasis.local.home>
In-Reply-To: <cover.1627568431.git.bristot@kernel.org>
References: <cover.1627568431.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 16:50:07 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> I started using libtracefs last week, and I am really impressed!
> 
> While learning about it, I ended up finding three small issues
> in the documentation, here they are.
> 
> Daniel Bristot de Oliveira (3):
>   libtracefs: Fix example in libtracefs-events-tep
>   libtracefs: Fix example in libtracefs-events
>   libtracefs: Fix a typo in libtracefs-files
> 
>

Thanks Daniel, I'll queue these up for my next push.

-- Steve
