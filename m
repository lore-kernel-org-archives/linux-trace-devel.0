Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0F1C388F7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Nov 2020 15:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71FD20789
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Nov 2020 15:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgKIP3B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 10:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbgKIP3B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 10:29:01 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A780206C0;
        Mon,  9 Nov 2020 15:29:00 +0000 (UTC)
Date:   Mon, 9 Nov 2020 10:28:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 20/20] kernel-shark: Integrate streams with
 libkshark-configio
Message-ID: <20201109102858.3297d087@oasis.local.home>
In-Reply-To: <af6f31bc-b5cb-d3fa-bb2f-fb953ef19734@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-21-y.karadz@gmail.com>
        <20201105142253.69485d76@gandalf.local.home>
        <af6f31bc-b5cb-d3fa-bb2f-fb953ef19734@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 9 Nov 2020 16:55:58 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> 
> In the review of patch 13/20 you already suggested to replace the name 
> "top" with a non-printable character:
> 
> const char top_name[] = { 0x1b, 0x00 }; // Non printable character
> #define TOP_NAME	(char *)&top_name

Ah, I forgot ;-)

> 
> This change will be included in v3.

OK, looking forward to it. (Yes, I'm still on PTO today :-)

-- Steve
