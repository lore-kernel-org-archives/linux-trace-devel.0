Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1306C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 19:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhLITPA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 14:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhLITPA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 14:15:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABA5C061746
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 11:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4E280CE27F1
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 19:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23811C004DD;
        Thu,  9 Dec 2021 19:11:22 +0000 (UTC)
Date:   Thu, 9 Dec 2021 14:11:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] libtracefs: New APIs for getting the raw format of
 synth event
Message-ID: <20211209141120.3951a22a@gandalf.local.home>
In-Reply-To: <d001cb6e-3d07-429a-148b-7d15f62ef1de@gmail.com>
References: <20211209163815.16769-1-y.karadz@gmail.com>
        <20211209132435.187422a8@gandalf.local.home>
        <d001cb6e-3d07-429a-148b-7d15f62ef1de@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 9 Dec 2021 21:07:28 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > Hmm, shouldn't this end with a \n? Or is it to allow quoting?  
> 
> The function returns string and the user is free to do anything with it. If this string ends with "\n" and you print 
> this string with puts() you will get extra line (same problem printing it in Python).

OK, that's fine.

-- Steve
