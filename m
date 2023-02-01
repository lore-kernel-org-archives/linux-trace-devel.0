Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554B0C38142
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Feb 2023 19:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjBATX1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Feb 2023 14:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjBATXO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Feb 2023 14:23:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A19761C9;
        Wed,  1 Feb 2023 11:23:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D42DB8228D;
        Wed,  1 Feb 2023 19:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44F9C433EF;
        Wed,  1 Feb 2023 19:23:07 +0000 (UTC)
Date:   Wed, 1 Feb 2023 14:23:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/6] rtla/osnoise: Add helper functions to manipulate
 osnoise/options
Message-ID: <20230201142305.4920f893@gandalf.local.home>
In-Reply-To: <930c4ef71c7bcb1158d2a8cad905f4de425b8d1e.1675181734.git.bristot@kernel.org>
References: <cover.1675181734.git.bristot@kernel.org>
        <930c4ef71c7bcb1158d2a8cad905f4de425b8d1e.1675181734.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 31 Jan 2023 17:30:02 +0100
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> Add some helper functions to read and set the on/off osnoise/options.
> No usage in this patch.
> 
> In preparation for hwnoise tool.

Honestly, I don't see why patches 1-5 isn't a single patch. It's not that
big of a change, and everything in 1-5 is to do what 5 does. Breaking it up
this fine grain isn't helpful in reviewing, as I found that I had to apply
1-5 and then do a diff from where I started to make sense of any of it.

-- Steve


> 
> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>
