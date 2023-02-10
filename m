Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD280C636D4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Feb 2023 21:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbjBJVrv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbjBJVrv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Feb 2023 16:47:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F48D3E0A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Feb 2023 13:47:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA486B825DB
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Feb 2023 21:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33258C433EF;
        Fri, 10 Feb 2023 21:47:47 +0000 (UTC)
Date:   Fri, 10 Feb 2023 16:47:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 0/2] Add initial support for meson
Message-ID: <20230210164744.53f1073d@gandalf.local.home>
In-Reply-To: <20230209093805.rg4sc3652in7smok@carbon.lan>
References: <20230208091204.7443-1-dwagner@suse.de>
        <20230209093805.rg4sc3652in7smok@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 9 Feb 2023 10:38:05 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> On Wed, Feb 08, 2023 at 10:12:02AM +0100, Daniel Wagner wrote:
> > The libtracecmd.pc didn't list the subdir 'trace-cmd' which caused
> > our kernelshard builds to fail.  
> 
> FWIW, I've updated the Tumbleweed packages (libtraceevent, libtracefs,
> libtracecmd, trace-cmd) to build with Meson and everything looks good now. As
> indicated there was only small fallout in our kernelshark build but that is now
> fixed with this latest version of these patches here. So all v7 of the patches
> are also properly tested in a productive environment.
> 
> All these changes don't touch the existing Makefiles, so there is zero chance
> that existing build setups break with adding the Meson build files. Obviously,
> there will be additional work to keep both builds working, though I don't expect
> it should be much after this initial work to get it going.
> 
> Steven, any chance you are going to apply them any time soon?

I'll take a look. Sorry I didn't get to it on my trip (other things came
up). Also, I'm still recovering from the flu now :-p

-- Steve
