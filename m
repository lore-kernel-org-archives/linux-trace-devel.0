Return-Path: <SRS0=f3YT=YQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755F3CA9EB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F8E821906
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733129AbfJWMAC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731954AbfJWMAC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 08:00:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4489320663;
        Wed, 23 Oct 2019 12:00:01 +0000 (UTC)
Date:   Wed, 23 Oct 2019 07:59:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark: Do not save the settings when running
 as Root
Message-ID: <20191023075959.337bf505@gandalf.local.home>
In-Reply-To: <05ece807-fb3f-fda5-e1f7-e04a63a1d0aa@gmail.com>
References: <20191018074722.6976-1-y.karadz@gmail.com>
        <20191018074722.6976-2-y.karadz@gmail.com>
        <20191018103238.3b3877cb@gandalf.local.home>
        <05ece807-fb3f-fda5-e1f7-e04a63a1d0aa@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Oct 2019 13:49:25 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> OK I think I have a solution that does a better job. Do you prefer to 
> resend all 3 patches or just this one?

Send them all again.

Thanks!

-- Steve
