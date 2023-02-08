Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F58C636CC
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Feb 2023 08:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjBHIs6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Feb 2023 03:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjBHIsw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Feb 2023 03:48:52 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35E0458A6
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Feb 2023 00:48:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2518634038;
        Wed,  8 Feb 2023 08:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675846128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uJvHlDvSJoBofJ3qQ4I58b8VjpmEZd52n1faygjQUl4=;
        b=GkQxEIPS3blbPvuSy/pJIMug8DPkVZ1J2yh/UcpBRFzX78K+zhK1ewH+elypMtMQJ5sN9Q
        iTey0mjWBJKePA8Ze0zDI6RhM0iQ6QZX4l+IfdXYMlilQN65tlO52qQAhkpQKfz0QWoZaU
        uFcKZ09tAXFB7OOa1FRLzTz3yRwZtUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675846128;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uJvHlDvSJoBofJ3qQ4I58b8VjpmEZd52n1faygjQUl4=;
        b=ZybN6/plRr5bhQ+72bPJN9s7X1ecSgPHJOY+gL3Xp8WcKyht5KHGVSVj5GJoVT4kgosyAz
        iJgrgR6xQ6u/OaAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1792A13A1F;
        Wed,  8 Feb 2023 08:48:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Kcu2BfBh42MhCAAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 08 Feb 2023 08:48:48 +0000
Date:   Wed, 8 Feb 2023 09:48:47 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Add initial support for meson
Message-ID: <20230208084847.e23adawpzszpw3eh@carbon.lan>
References: <20230207124634.6515-1-dwagner@suse.de>
 <20230207134825.uexdcqlopkuqehuy@carbon.lan>
 <20230207101001.5ef90b44@gandalf.local.home>
 <20230207154546.zqfq27swtc66ar2v@carbon.lan>
 <20230207161947.ju3fl7k7isffqeuo@carbon.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207161947.ju3fl7k7isffqeuo@carbon.lan>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 07, 2023 at 05:19:47PM +0100, Daniel Wagner wrote:
 There is something wierd going with the libtracecmd build in our build system.
> It produces a libtrace-cmd.pc and not a libtracecmd.pc file but this was
> with the v2 version of the meson patches. Doesn't happen with libtracecmd v5.

Finally found the problem in build setup. The generated pkg-config file
doesn't include the trace-cmd subdir. I'll send an update on this patches.
