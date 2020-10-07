Return-Path: <SRS0=fydL=DO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DF2C4363C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 20:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC6220872
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Oct 2020 20:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgJGUI3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:08:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgJGUI3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 16:08:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC25A207EA;
        Wed,  7 Oct 2020 20:08:28 +0000 (UTC)
Date:   Wed, 7 Oct 2020 16:08:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 03/15] kernel-shark: Start introducing KernelShark 2.0
Message-ID: <20201007160826.466bcfcf@gandalf.local.home>
In-Reply-To: <20200929134123.178688-4-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
        <20200929134123.178688-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Sep 2020 16:41:11 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> This is the very first patch from a series of patches that will
> introduce KernelShark 2.0. The new version implies significant
> changes in the low level C API, used by the KernelShark GUI. As
> a consequence of the API modifications, significant changes are
> needed in every source file of the project. Because, we want to
> avoid having a huge and ugly single commit that will be extremely
> hard to review, we will introduce a regression. We will first
> disable the compilation of all sub-components of KernelShark,
> except the API itself. This is done by bypassing the search of
> the necessary third party components (OpenGL and Qt). Later we
> will introduce the changes of the API in several sub-steps and
> will re-enable one by one the modified components of the GUI.

OK, this isn't what I was thinking. It's no different than just letting the
code break the build, because it doesn't allow use to bisect through this
either.

-- Steve
