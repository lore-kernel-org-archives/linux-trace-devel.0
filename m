Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE33C636CC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Feb 2023 07:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBMHyd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Feb 2023 02:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMHyc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Feb 2023 02:54:32 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FD359D5
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Feb 2023 23:54:31 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 66F86677F6;
        Mon, 13 Feb 2023 07:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676274870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Oru6s1M5yzTl6IZqR29yspnFwsqek5JQAKE9wGBio8=;
        b=GFbSav0lUb2d8ZvtZR3htFwmM/xNWvFfkaa4MKqx5cNhjdk5oPGXJhqa7aAT0cLqokYMfs
        Kil+WXv++3Bfz2JToXMiTAn9d7kK65D5iaeGD6N2MQoo0a5ouq9JflUhPgtzvqPHI+YM3A
        tJcUm/yM4lnZfk5cOuV83bpct07PCb4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676274870;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Oru6s1M5yzTl6IZqR29yspnFwsqek5JQAKE9wGBio8=;
        b=WDBUMYsN7QoXW/lSE6i3wj2SgHtUs6ZxH3KiXjoVzlLXOgScLNO6iiiVfbtO9mwnQLxLnu
        nEEHHlVaqdkE9kCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 591A8138E6;
        Mon, 13 Feb 2023 07:54:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2PCaFbbs6WMGKgAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 13 Feb 2023 07:54:30 +0000
Date:   Mon, 13 Feb 2023 08:54:29 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 0/2] Add initial support for meson
Message-ID: <20230213075429.7a3j564qzlcpcsxm@carbon.lan>
References: <20230208091204.7443-1-dwagner@suse.de>
 <20230209093805.rg4sc3652in7smok@carbon.lan>
 <20230210164744.53f1073d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210164744.53f1073d@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 10, 2023 at 04:47:44PM -0500, Steven Rostedt wrote:
> I'll take a look. Sorry I didn't get to it on my trip (other things came
> up). Also, I'm still recovering from the flu now :-p

Thanks! No hurry, I don't have a problem if takes some more time if it moves
forward eventually :)
