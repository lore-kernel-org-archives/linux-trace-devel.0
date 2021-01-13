Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90431C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jan 2021 14:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492E12343E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jan 2021 14:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbhAMOjj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jan 2021 09:39:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbhAMOji (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jan 2021 09:39:38 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA5123434;
        Wed, 13 Jan 2021 14:38:57 +0000 (UTC)
Date:   Wed, 13 Jan 2021 09:38:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix lib audit warning message
Message-ID: <20210113093856.12cd8620@gandalf.local.home>
In-Reply-To: <c7d7a2f9-78cf-366f-44ec-e1695c019443@gmail.com>
References: <CAK7tX=bWn89VxofeyK0hfb4_dQz3tKG2Y2+_47WnaYiWN5UN2w@mail.gmail.com>
        <20210112122906.33c959f2@gandalf.local.home>
        <c7d7a2f9-78cf-366f-44ec-e1695c019443@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Jan 2021 21:40:45 +0530
sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> hi steve,
> 
> please check now.
> 

No, unfortunately its still corrupted. Can you try sending with git?

 https://coderwall.com/p/qcsiew/setting-up-and-using-git-send-email-with-gmail

-- Steve
