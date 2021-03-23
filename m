Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD433C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 13:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91134619BF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 13:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhCWNG5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 09:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhCWNGt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 09:06:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C955619B8;
        Tue, 23 Mar 2021 13:06:48 +0000 (UTC)
Date:   Tue, 23 Mar 2021 09:06:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Prefer using const pointer arguments
Message-ID: <20210323090647.357b4275@gandalf.local.home>
In-Reply-To: <c414dd4b-60c3-bdfb-0e23-ee9c307a3518@gmail.com>
References: <20210322142912.26521-1-y.karadz@gmail.com>
        <20210322114721.118c83ae@gandalf.local.home>
        <64861357-e2ef-e2aa-239c-9b8a96a5bf9b@gmail.com>
        <20210322182917.622f6126@gandalf.local.home>
        <c414dd4b-60c3-bdfb-0e23-ee9c307a3518@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Mar 2021 14:58:07 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> I really need to change all "char *" arguments to "const char *". 
> Changing "tracefs_instance *" to "const tracefs_instance *" is more a 
> style preference.

I totally agree on the "char *" to "const char *", as that can make a huge
difference.

I'm not adverse to the "const struct tracefs_instance *" change, I'm just
hesitant due to my years of torment by non flexible APIs ;-)

-- Steve
