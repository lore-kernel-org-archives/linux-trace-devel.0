Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1647C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Nov 2022 09:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKYJVC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKYJVB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 04:21:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B901F2CB
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Nov 2022 01:21:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B4C8C21ADD;
        Fri, 25 Nov 2022 09:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669368059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=yRDyR1j1w7kEpDgGdhQTf8xrhfSARJDqhy8Oy6Libkk=;
        b=aijYs7yK1XeNI+xtkdBT9CozFR279lZ76fsRRSQvC4OyNVNd6fibheV17jGcjbouQgahXu
        Zjsjs9stVwAxkeFH/foU+s0NpWUum9+j5omaWcsr1CVGOIgKu0bWn4FtEr9dXKtVOpHqYA
        Ys6rSTBij/ad8ZyeagCu4jCDPyIjLsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669368059;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=yRDyR1j1w7kEpDgGdhQTf8xrhfSARJDqhy8Oy6Libkk=;
        b=sbGzTcYAF4JpTJbTG9kIUo5vPuDMaVXr0WkAYsz9q3iePJ699X4NG4jSiOdEn6kmpz6ORw
        xQFTfn9zkipjyMBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8903B1361C;
        Fri, 25 Nov 2022 09:20:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qMcdHfuIgGOpRQAAMHmgww
        (envelope-from <dwagner@suse.de>); Fri, 25 Nov 2022 09:20:59 +0000
Date:   Fri, 25 Nov 2022 10:20:58 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     factory@lists.opensuse.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: trace-cmd build fails due to due make 'not recursively expanding'
Message-ID: <20221125092058.poa4hzmz4mve7otm@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

trace-cmd stop building and due to make getting stuck in loop
and complaining with:

  $ make -d
  GNU Make 4.4
  Built for x86_64-suse-linux-gnu
  Copyright (C) 1988-2022 Free Software Foundation, Inc.
  License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.
  Reading makefiles...
  Reading makefile 'Makefile'...
  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
  Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
  Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
  Makefile:225: not recursively expanding LIBTRACECMD_SHARED_SO to export to shell function
  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
  Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
  Makefile:225: not recursively expanding LIBTRACECMD_SHARED_SO to export to shell function
  Makefile:225: not recursively expanding LIBTRACECMD_SHARED_SO to export to shell function
  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
  [...]

I don't really know what's going on. Any ideas?

This happens with our packaged version in Tumbleweed but also with the
plain upstream latest git version of trace-cmd. If I got it right make
was updated recently to 4.4.

Daniel
