Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE65C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbjADRKt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239927AbjADRKU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:10:20 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA931A3A1
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:10:20 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B1B2B3EC3D;
        Wed,  4 Jan 2023 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672852218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BLhRaMISb6k+yYVIsju9R/h3gksxa4gPn7NVfksbaoY=;
        b=a5XcrVVmSrt6IKGyrilHtmAm9F9Gh3TLit7XkngX6NWG2Aq9281Vzi4JPkDqFykN7VOY10
        knUZmysKQf2hw+qFcKB55pOnIca7DrpyVA6CEIhwKxBvyWPGeNRH+JRCF7VAnJ7L+uhyhh
        O2jNanX1ivNSO8i6MqSsscq4c+KMOpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672852218;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BLhRaMISb6k+yYVIsju9R/h3gksxa4gPn7NVfksbaoY=;
        b=YQZaw544/ZFh3MU/tXjIxnEHqkIpyBbx4q7yy4JaLK46QuS+ShM1aATG165JVg0SNqVUOp
        /y3BldtUB3Q4IAAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A4A4A1342C;
        Wed,  4 Jan 2023 17:10:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yvgvKPqytWM0JgAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 04 Jan 2023 17:10:18 +0000
Date:   Wed, 4 Jan 2023 18:10:18 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230104171018.pghozcx2c6wyak72@carbon.lan>
References: <20221228082906.3272-1-dwagner@suse.de>
 <20230104110128.1cabdf08@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104110128.1cabdf08@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 04, 2023 at 11:01:28AM -0500, Steven Rostedt wrote:
> On Wed, 28 Dec 2022 09:29:06 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > In case you want to build/install the documentation the setup is
> > 
> >   meson -Ddocs-build=true .build
> > 
> > Signed-off-by: Daniel Wagner <dwagner@suse.de>
> 
> Can we make this so that building docs does not require building the rest
> of the code?

Yes, it could be done by introducing a new target which is not run per
default. Currently, the docs are not added to the build when
'-Ddocs-build=true' is missing.

If I understood you correctly you prefer:

  meson setup .build
  meson compile -C .build
  meson compile -C .build doc

and drop the '-Ddocs-build' option?
