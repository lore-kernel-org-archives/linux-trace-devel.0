Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3269EC5B57D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 23:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E60821738
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 23:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfGEXee (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 19:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfGEXee (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 19:34:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5751821670;
        Fri,  5 Jul 2019 23:34:33 +0000 (UTC)
Date:   Fri, 5 Jul 2019 19:34:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>,
        "troyengel@gmail.com" <troyengel@gmail.com>
Subject: Re: [PATCH v2 3/3] kernel-shark: Define a CMAKE_BUILD_TYPE
 "Package"
Message-ID: <20190705193431.7594c3f2@gandalf.local.home>
In-Reply-To: <20190614132609.16465-4-ykaradzhov@vmware.com>
References: <20190614132609.16465-1-ykaradzhov@vmware.com>
        <20190614132609.16465-4-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 Jun 2019 13:26:59 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> A special build type dedicated for package maintainers is added.
> By default this build type adds the "-O2" compiler flag. Users
> can chose their own compiler flags by providing the corresponding
> CMAKE_XXXX_FLAGS_PACKAGE Command-Line options.
> 
> If no type is specified, the build type will be "Debug".
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>

Hmm, after applying this commit, I get this:

 <trace-cmd.git># make install_gui
 <trace-cmd.git># cd
 <~/># kernelshark
kernelshark: error while loading shared libraries: libkshark-gui.so.0.9.8: cannot open shared object file: No such file or directory

-- Steve
