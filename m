Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2C2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Nov 2022 10:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiKYKPo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 05:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKYKPn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 05:15:43 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0978631DE8
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Nov 2022 02:15:39 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 308095A115D8E; Fri, 25 Nov 2022 11:15:38 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 2E29260E254AA;
        Fri, 25 Nov 2022 11:15:38 +0100 (CET)
Date:   Fri, 25 Nov 2022 11:15:38 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Daniel Wagner <dwagner@suse.de>
cc:     factory@lists.opensuse.org, linux-trace-devel@vger.kernel.org
Subject: Re: trace-cmd build fails due to due make 'not recursively
 expanding'
In-Reply-To: <20221125092058.poa4hzmz4mve7otm@carbon>
Message-ID: <1o2r1723-o3o5-3p83-8131-896soq68o76@vanv.qr>
References: <20221125092058.poa4hzmz4mve7otm@carbon>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On Friday 2022-11-25 10:20, Daniel Wagner wrote:
>
>trace-cmd stop building and due to make getting stuck in loop
>and complaining with:
>
>  $ make -d
>  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>
>I don't really know what's going on. Any ideas?

https://lists.opensuse.org/archives/list/factory@lists.opensuse.org/thread/FPNDORIL6NDJD3HFQ76LQBIRBCWVG6TV/
(I already informed Steven last night via email. / Wasn't aware there 
is a linux-trace-devel@)
