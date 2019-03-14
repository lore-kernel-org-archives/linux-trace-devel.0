Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298D7C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 23:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DDB21873
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 23:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfCNXrN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 19:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfCNXrN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 19:47:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A1C217F5;
        Thu, 14 Mar 2019 23:47:12 +0000 (UTC)
Date:   Thu, 14 Mar 2019 19:47:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 06/12] kernel-shark: Load Last Session from command line
Message-ID: <20190314194711.62436074@gandalf.local.home>
In-Reply-To: <20190314151012.905-7-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
        <20190314151012.905-7-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Mar 2019 17:10:06 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> ./kernelshark -l  will load directly the Last Session
> 
> Signed-off-by : Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/kernelshark.cpp | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/src/kernelshark.cpp b/kernel-shark/src/kernelshark.cpp
> index 2ec91de..1ec6678 100644
> --- a/kernel-shark/src/kernelshark.cpp
> +++ b/kernel-shark/src/kernelshark.cpp
> @@ -28,6 +28,7 @@ void usage(const char *prog)
>  	printf("  -p	register plugin, use plugin name, absolute or relative path\n");
>  	printf("  -u	unregister plugin, use plugin name or absolute path\n");
>  	printf("  -s	import a session\n");
> +	printf("  -l	import the last session\n");
>  }
>  
>  int main(int argc, char **argv)
> @@ -40,7 +41,7 @@ int main(int argc, char **argv)
>  	int c;
>  	bool fromSession = false;
>  
> -	while ((c = getopt(argc, argv, "hvi:p:u:s:")) != -1) {
> +	while ((c = getopt(argc, argv, "hvi:p:u:s:l")) != -1) {
>  		switch(c) {
>  		case 'h':
>  			usage(argv[0]);
> @@ -65,6 +66,12 @@ int main(int argc, char **argv)
>  		case 's':
>  			ks.loadSession(QString(optarg));
>  			fromSession = true;
> +			break;
> +
> +		case 'l':
> +			ks.loadSession(ks.lastSessionFile());
> +			fromSession = true;
> +			break;

This produces:

[ 69%] Building CXX object src/CMakeFiles/kernelshark.dir/kernelshark.cpp.o
/work/git/trace-cmd.git/kernel-shark/src/kernelshark.cpp: In function ‘int main(int, char**)’:
/work/git/trace-cmd.git/kernel-shark/src/kernelshark.cpp:72:22: error: ‘class KsMainWindow’ has no member named ‘lastSessionFile’; did you mean ‘loadSession’?
    ks.loadSession(ks.lastSessionFile());
                      ^~~~~~~~~~~~~~~
                      loadSession


Am I missing something?

-- Steve

>  
>  		default:
>  			break;

