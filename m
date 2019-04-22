Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8873EC10F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 11:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AE782077C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 11:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfDVLud (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 07:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfDVLud (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 07:50:33 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0128820693;
        Mon, 22 Apr 2019 11:50:31 +0000 (UTC)
Date:   Mon, 22 Apr 2019 07:50:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 4/8] kernel-shark: Add logic for the plugins search
 path
Message-ID: <20190422075029.232f9b64@oasis.local.home>
In-Reply-To: <06f28287-93ee-ffc9-3603-3b67c8e1aa24@gmail.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
        <20190419135036.19340-5-ykaradzhov@vmware.com>
        <20190419132815.2820b6af@gandalf.local.home>
        <06f28287-93ee-ffc9-3603-3b67c8e1aa24@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Apr 2019 14:29:49 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> > I was hoping to test:
> > 
> > 	string = cmdline_path() + "../../kernel-shark/lib/";
> > 
> > If that exists, then we know that we are in the source directory.  
> 
> I don't thing this is a good idea. If we search for plugins in a path 
> that is defined like this:
>   cmdline_path() + "/something/hard/coded/lib/"

Your missing the "../.." part.

> 
> Then the GUI will do one thing when started like this:
> ./kernelshark
> 
> and anther thing when started like this:
> bin/kernelshark

No it shouldn't, unless you moved the binary.

I said to add "../../plugins" to the path that the kernelshark binary
is executed from. If you were to move kernelshark, then yes. it would
not longer give you the same result.

If the binary is in:

 kernelshark/bin/kernelshark

and you ran it as: kernelshark/bin/kernelshark using the path
"kernelshark/bin" and adding "../lib" would give you "kernelshark/lib"
directory.

 "kernelshark/bin/../lib" == "kernelshark/lib"

Also, if you were to cd to kernelshark and run

 "bin/kernelshark" the path would be "bin/../lib" which would be
 equal to  "lib" and being in the kernelshark directory, would
 give you the plugins directory that is the same as the previous command.

If you cd to kernelshark/bin and ran "./kernelshark" we would then use
"./../lib" which is the same as "../lib" which is still the same path
as the other two.

But last call we discussed a way to find the full path name of the
binary being executed. And if that's the case, we could not only add
"../lib" we could also check that the binary being executed is also in
a "kernelshark/bin" first.

> 
> and this can be very surprising behavior for the user
> 
> The other solution has it own weaknesses, but at least it sounds like a 
> simple rule: "If you want to use the compiled version of the plugins you 
> have to start the GUI from the source code directory used to build. 
> Otherwise the installed version of the plugins will be used."

Building from source, then moving that source tree to another path
shouldn't cause the binary to act differently.

-- Steve
