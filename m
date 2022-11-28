Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A79EC43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Nov 2022 15:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiK1PpF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Nov 2022 10:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbiK1PpE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Nov 2022 10:45:04 -0500
X-Greylist: delayed 181 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 07:45:02 PST
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6955D1DA61
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Nov 2022 07:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669650115;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oSb1anPmVpOlHHqeYXx02QQTQoyjMONmQpuH30Imcrk=;
    b=OQ9TjY9kBDnVaSymC78H0Qr9y53nsteSXFRClKvxg7T7j7lPeg1EFPOAatoNEdMxlQ
    sW0tzNS3qcD57VBqMh4NTfLjOLhTxs0kGWi5JOaqUC81MYANOlGuPfwpk/NlIbNvCiVS
    f4oCThoGRWM7Jg0lcz28DRdP1zQrwGiIGWaBwSVFyXPHUq67K2QX7IFithBglBO7Qe4n
    g9cGxbeJWq4IlJ56gxg3UyfpiDVnBRzA6LGVeti0IPo3w99QT0Tnhnl9P6iy39l4ynAj
    i/sLP6xvCEKpJUw19zQDUPduyJ97dbEkhLfTvFPNTp2hdgDHqCszJmvQK0UdlAUK3gqz
    YZKw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSeBwhhSxarlUcu05JCAPyj3VPAceccYJs0uz"
X-RZG-CLASS-ID: mo00
Received: from blinux
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id z9cfbfyASFfs4kl
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 28 Nov 2022 16:41:54 +0100 (CET)
Message-ID: <e6c020fc59cd3a2333806fbaf2a90092866fb7b7.camel@iokpp.de>
Subject: Re: [PATCH] libtracefs: Fix wrong return value in
 tracefs_tracing_dir_is_mounted()
From:   Bean Huo <beanhuo@iokpp.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Bean Huo <beanhuo@micron.com>
Date:   Mon, 28 Nov 2022 16:41:54 +0100
In-Reply-To: <20221128102410.5ccf784d@gandalf.local.home>
References: <20221128132106.291101-1-beanhuo@iokpp.de>
         <20221128102410.5ccf784d@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 2022-11-28 at 10:24 -0500, Steven Rostedt wrote:
> On Mon, 28 Nov 2022 14:21:06 +0100
> 
> Bean Huo <beanhuo@iokpp.de> wrote:
> 
> 
> 
> > From: Bean Huo <beanhuo@micron.com>
> > If it eventually mounts successfully, it should return 1 instead of
> > 0, otherwise it will make the caller's verification logic more
> > complicated
> 
> 
> The man page shows:
> 
> 
> 
>   The tracefs_tracing_dir_is_mounted() returns 1 if the tracing
> directory is
> 
>   already mounted, 0 if it is not, and -1 on error.
> 
> 
> 
> If you only want to mount it and not care if it was already mounted
> then
> 
> use tracefs_tracing_dir(), as it will return the path of the mount
> point
> 
> and try to mount it if it is not already, or NULL if it could not
> mount it.
> 
> 
> 

Hi Steve,

I used to reply on tracefs_tracing_dir(). But after updated the
libtracefs yesterday, I found my app doesn't work as before, then
checked the changelog, and switch to use
tracefs_tracing_dir_is_mounted. 

in your latest libtracefs:


const char *tracefs_tracing_dir(void) {

...
tracing_dir = trace_find_tracing_dir(false);//shold be changed to true?
...
	
}


__hidden char *trace_find_tracing_dir(bool debugfs)
{
        return find_tracing_dir(debugfs, false);
}



static char *find_tracing_dir(bool debugfs, bool mount) {

...
	if (!mount || mount_debugfs() < 0)
		return NULL;


...


}


Kind regards,
Bean


