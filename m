Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04814C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 14:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbiBXOWl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 09:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbiBXOWY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 09:22:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FE11B7A0
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 06:21:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A8DB82604
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 14:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA61C340EC;
        Thu, 24 Feb 2022 14:21:46 +0000 (UTC)
Date:   Thu, 24 Feb 2022 09:21:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cruncher: Check required library versions before
 building
Message-ID: <20220224092144.024c51c9@gandalf.local.home>
In-Reply-To: <20220224085233.112129-1-y.karadz@gmail.com>
References: <20220224085233.112129-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 24 Feb 2022 10:52:33 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

>      include_dirs = [np.get_include()]
> -    include_dirs.extend(pkg_traceevent['include_dirs'])
> -    include_dirs.extend(pkg_ftracepy['include_dirs'])
> -    include_dirs.extend(pkg_tracecmd['include_dirs'])
> -    include_dirs.extend(pkg_kshark['include_dirs'])
> +    libs_required = [('libtraceevent', '1.5.0'),
> +                     ('libtracefs',    '1.3.0'),

Nice :-)

-- Steve

> +                     ('libkshark',     '2.0.1')]
> +    libs_found = []
