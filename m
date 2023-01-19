Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B727C004D4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Jan 2023 21:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjASVLt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Jan 2023 16:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjASVKT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Jan 2023 16:10:19 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AE4A5CF1
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Jan 2023 13:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=KsVxYe493tx3OaArUzMAblM3SgjynNuIVghAlIMVXNI=;
        t=1674162210; x=1675371810; b=AuB2zR9O77R1lxgKI9lhyHD5Ec6MovojWHQ2IcGV+rD3LJK
        9by7Y15uBrM0IodaHMJCpoEvyoAi/4lmvdlbTiR/o08YTFqrTwT2rPGNZhbKcHQ1KzvsMJ7pdrxhG
        0Ak6TpMyQdsglfrI6ORP1IPtNllKdO1GqHblA3Aob1ZrEW5KpTT0ljDNGoY4HPDlnkeXyhcV1o3wT
        Yb+2snSLSkITG771dAcKyzvVOleiYKd4qw9Ng0o1N5PxKcdbTS8A+H4i+vx5Fo8TVpfjUdWC3lMl2
        IeuGvsZBEilqkFenKuo1X2TfAYQTdGfg5hgVQYEIAAWrbln0TC2wTtGSZL3h+PEg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pIc4G-006fOB-1a;
        Thu, 19 Jan 2023 22:03:28 +0100
Message-ID: <d1ab88e414c66197163b80951fcf8639fb3d8f89.camel@sipsolutions.net>
Subject: Re: [PATCH] trace-cmd record: Verify that splice works before using
 it
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Thu, 19 Jan 2023 22:03:27 +0100
In-Reply-To: <20220608130527.26e50cba@gandalf.local.home>
References: <20220608130527.26e50cba@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2022-06-08 at 13:05 -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>=20
> Add a test to make sure that splice works on the source directory before
> using it, and if not automatically switch over to read/write method.
>=20
> Suggested-by: Johannes Berg <johannes@sipsolutions.net>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D213659
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Johannes, can you test this?
> I want to make sure that it fixes the issue.
>=20

Umm, yeah, long time ago. Sorry, I've been meaning to do that, but it
isn't easy, so I kept pushing it off.

My use case for this was UML with hostfs, which I've since fixed (kernel
upstream commit 1568cb0e6d97 ("hostfs: support splice_write"); I can
revert that easily of course, but then I still have to build my own
trace-cmd with that patch... But that needs libtracefs 1.6 which even
Fedora doesn't ship.

Given that you've merged the patch already, I think I'll just give up on
testing it, sorry about that.

johannes
