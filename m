Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C1BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Nov 2022 16:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiK1QaF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Nov 2022 11:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbiK1QaA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Nov 2022 11:30:00 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E16421888
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Nov 2022 08:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669652991;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=PSasiXQU+68UbbYwOA4/WD5UqUc5opf3BDFeuOv5D3c=;
    b=AuaFA7lAVD3biQCmAELtz0Xwzo+YNwT5GpxKjNRagW3IwVHwaOUq0bJmIk7exM1a+e
    aMIWib4hAjlVVLz3ptquB+D3N0Rbwgsf1H4nVtvf/+rNMffSB/fBeEGc8LpVtsH8KxFP
    bkx3Lbrq2yLm6Q+iAEpjHcad5VKoG3pW7C2alHfGMspmxUTHNQPmjCAppgzOdv68wl+2
    WF6TjuQ8ZfVK2cDFJSjqbMqoTD3xN85nwPY5zGAEVsTAVb7Iw4Rd3K87bRvwPdwtYOz3
    oEgC9AN2rnTnFCNly9ac8sIfQkpRqu7D6fLgis4R7ZR073qJmqVLmaejxMMvCWYb+rYg
    mdkA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSeBwhhSxarlUcu05JCAPyj3VPAceccYJs0uz"
X-RZG-CLASS-ID: mo00
Received: from blinux
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id z9cfbfyASGTp4xe
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 28 Nov 2022 17:29:51 +0100 (CET)
Message-ID: <85c4e8cf7dfab9cd2f2e6c247e11336d5d3e66f2.camel@iokpp.de>
Subject: Re: [PATCH] libtracefs: Fix wrong return value in
 tracefs_tracing_dir_is_mounted()
From:   Bean Huo <beanhuo@iokpp.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Bean Huo <beanhuo@micron.com>
Date:   Mon, 28 Nov 2022 17:29:50 +0100
In-Reply-To: <e6c020fc59cd3a2333806fbaf2a90092866fb7b7.camel@iokpp.de>
References: <20221128132106.291101-1-beanhuo@iokpp.de>
         <20221128102410.5ccf784d@gandalf.local.home>
         <e6c020fc59cd3a2333806fbaf2a90092866fb7b7.camel@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 2022-11-28 at 16:41 +0100, Bean Huo wrote:
> On Mon, 2022-11-28 at 10:24 -0500, Steven Rostedt wrote:
> > On Mon, 28 Nov 2022 14:21:06 +0100
> > 
> > Bean Huo <beanhuo@iokpp.de> wrote:
> > 
> > 
> > 
> > > From: Bean Huo <beanhuo@micron.com>
> > > If it eventually mounts successfully, it should return 1 instead
> > > of
> > > 0, otherwise it will make the caller's verification logic more
> > > complicated
> > 
> > The man page shows:
> > 
> > 
> > 
> >   The tracefs_tracing_dir_is_mounted() returns 1 if the tracing
> > directory is
> > 
> >   already mounted, 0 if it is not, and -1 on error.
> > 
> > 
> > 
> > If you only want to mount it and not care if it was already mounted
> > then
> > 
> > use tracefs_tracing_dir(), as it will return the path of the mount
> > point
> > 
> > and try to mount it if it is not already, or NULL if it could not
> > mount it.
> > 
> > 
> > 
> 
> Hi Steve,
> 
> I used to reply on tracefs_tracing_dir(). But after updated the
> libtracefs yesterday, I found my app doesn't work as before, then
> checked the changelog, and switch to use
> tracefs_tracing_dir_is_mounted. 
> 
> in your latest libtracefs:
> 
> 
> const char *tracefs_tracing_dir(void) {
> 
> ...
> tracing_dir = trace_find_tracing_dir(false);//shold be changed to
> true?
> ...
> 	
> }
> 
> 
> __hidden char *trace_find_tracing_dir(bool debugfs)
> {
>         return find_tracing_dir(debugfs, false);
> }
> 
> 
> 
> static char *find_tracing_dir(bool debugfs, bool mount) {
> 
> ...
> 	if (!mount || mount_debugfs() < 0)
> 		return NULL;
> 
> 
> ...
> 
> 
> }
> 
> 


instead of changing tracefs_tracing_dir_is_mounted(), or we could
change trace_find_tracing_dir(), let it mount the tracefs in case of it
is not mounted when we call tracefs_tracing_dir():



--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -200,7 +200,7 @@ int tracefs_tracing_dir_is_mounted(bool mount,
const char **path)
  */
 __hidden char *trace_find_tracing_dir(bool debugfs)
 {
-       return find_tracing_dir(debugfs, false);
+       return find_tracing_dir(debugfs, true);
 }


Kind regard,
Bean

