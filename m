Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3DFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 16:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbiCNQPy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 12:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiCNQPy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 12:15:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302E3403EB
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 09:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E00A3B80D40
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 16:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BAEC340E9;
        Mon, 14 Mar 2022 16:14:35 +0000 (UTC)
Date:   Mon, 14 Mar 2022 12:14:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] trace-cmd library: Fix sparse cpu_data
Message-ID: <20220314121433.4d13f41c@gandalf.local.home>
In-Reply-To: <e3cf4859-f9e2-6919-1851-a0f8bc343504@gmail.com>
References: <20220312234032.127108-1-rostedt@goodmis.org>
        <7aeb8865-3f66-3938-14a6-48b3147455ec@gmail.com>
        <20220314120111.5e981ed4@gandalf.local.home>
        <e3cf4859-f9e2-6919-1851-a0f8bc343504@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Mar 2022 18:05:44 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > On Mon, 14 Mar 2022 16:59:13 +0200
> > Yordan Karadzhov <y.karadz@gmail.com> wrote:
> >   
> >> Is this fixing the issue with kernelshark crashing when trying to open the new format?  
> > 
> > Yes, it was.  
> 
> And are all this CPUs (active or idle) being properly displayed by KS?

After the fix it seems to be.

You can check it out yourself:

  http://rostedt.org/private/trace-data/gentoo/trace.dat


-- Steve
