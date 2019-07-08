Return-Path: <SRS0=JD1t=VF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56F5C606AF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 13:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5CBF20844
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Jul 2019 13:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfGHN0g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 09:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbfGHN0g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 09:26:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378BA204EC;
        Mon,  8 Jul 2019 13:26:34 +0000 (UTC)
Date:   Mon, 8 Jul 2019 09:26:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: Re: [PATCH v3] kernel-shark: Define a CMAKE_BUILD_TYPE "Package"
Message-ID: <20190708092632.0062411b@gandalf.local.home>
In-Reply-To: <20190708091945.439-1-y.karadz@gmail.com>
References: <20190708091945.439-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/wCpN1YMqD+hGPZu/oY67mJF"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

--MP_/wCpN1YMqD+hGPZu/oY67mJF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon,  8 Jul 2019 12:19:45 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> From: Yordan Karadzhov <ykaradzhov@vmware.com>
> 
> A special build type dedicated for package maintainers is added.
> By default this build type adds the "-O3" compiler flag. Users
> can chose their own compiler flags by providing the corresponding
> CMAKE_XXXX_FLAGS_PACKAGE Command-Line options.
> 
> If no types is specified, the build type will be "Debug".
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> 

Thanks Yordan!

I applied and pushed most your patches upstream.

I started to play a little with the record feature, and found some
issues.

 1) It still adds a -e'event' for all events when a system is selected.
    Can we just make it use the system? -eirq instead of
    -eirq:irq_handler_entry -eirq:irq_handler_exit -eirq...

 2) When I executed it, it gave me an error, and then crashed
    kernelshark. It should check the status of the run before it tries
    to reload it.

 3) I saved the report as the recorder was still running (but
    kernelshark crashed). And then when I loaded the report (attached)
    it just executed it. The "import" should just pull it in and load
    the settings. This way, one could make updates to a default saved
    record.

These probably should be fixed before ks1.0 is released.

Thanks!

-- Steve

--MP_/wCpN1YMqD+hGPZu/oY67mJF
Content-Type: application/json
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=test-record.json

ewogICAidHlwZSI6ICJrc2hhcmsuY29uZmlnLnJlY29yZCIsCiAgICJFdmVudHMiOiB7CiAgICAg
InR5cGUiOiAia3NoYXJrLmNvbmZpZy5maWx0ZXIiLAogICAgICJFdmVudHMiOiBbCiAgICAgICB7
CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3RvcnMiLAogICAgICAgICAibmFtZSI6ICJ2ZWN0
b3JfYWN0aXZhdGUiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV92
ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAicmVzY2hlZHVsZV9leGl0IgogICAgICAgfSwKICAg
ICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfbWF0cml4IiwKICAgICAgICAgIm5hbWUiOiAi
aXJxX21hdHJpeF9yZXNlcnZlIgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6
ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJuYW1lIjogInZlY3Rvcl9jbGVhciIKICAgICAgIH0s
CiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAic2NoZWQiLAogICAgICAgICAibmFtZSI6ICJz
Y2hlZF9wcm9jZXNzX2ZvcmsiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjog
ImlycV92ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAieDg2X3BsYXRmb3JtX2lwaV9lbnRyeSIK
ICAgICAgIH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3RvcnMiLAogICAg
ICAgICAibmFtZSI6ICJkZWZlcnJlZF9lcnJvcl9hcGljX2V4aXQiCiAgICAgICB9LAogICAgICAg
ewogICAgICAgICAic3lzdGVtIjogImlycV9tYXRyaXgiLAogICAgICAgICAibmFtZSI6ICJpcnFf
bWF0cml4X2FsbG9jIgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJzY2hl
ZCIsCiAgICAgICAgICJuYW1lIjogInNjaGVkX21pZ3JhdGVfdGFzayIKICAgICAgIH0sCiAgICAg
ICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3RvcnMiLAogICAgICAgICAibmFtZSI6ICJ2
ZWN0b3Jfc2V0dXAiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV92
ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAibG9jYWxfdGltZXJfZXhpdCIKICAgICAgIH0sCiAg
ICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxIiwKICAgICAgICAgIm5hbWUiOiAic29mdGly
cV9lbnRyeSIKICAgICAgIH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3Rv
cnMiLAogICAgICAgICAibmFtZSI6ICJjYWxsX2Z1bmN0aW9uX3NpbmdsZV9lbnRyeSIKICAgICAg
IH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX21hdHJpeCIsCiAgICAgICAgICJu
YW1lIjogImlycV9tYXRyaXhfYWxsb2NfcmVzZXJ2ZWQiCiAgICAgICB9LAogICAgICAgewogICAg
ICAgICAic3lzdGVtIjogImlycV92ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAidmVjdG9yX2Fs
bG9jIgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfdmVjdG9ycyIs
CiAgICAgICAgICJuYW1lIjogImlycV93b3JrX2V4aXQiCiAgICAgICB9LAogICAgICAgewogICAg
ICAgICAic3lzdGVtIjogImlycV9tYXRyaXgiLAogICAgICAgICAibmFtZSI6ICJpcnFfbWF0cml4
X29ubGluZSIKICAgICAgIH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3Rv
cnMiLAogICAgICAgICAibmFtZSI6ICJ2ZWN0b3JfY29uZmlnIgogICAgICAgfSwKICAgICAgIHsK
ICAgICAgICAgInN5c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJuYW1lIjogImVycm9y
X2FwaWNfZW50cnkiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV92
ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAidGhyZXNob2xkX2FwaWNfZXhpdCIKICAgICAgIH0s
CiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX21hdHJpeCIsCiAgICAgICAgICJuYW1l
IjogImlycV9tYXRyaXhfYWxsb2NfbWFuYWdlZCIKICAgICAgIH0sCiAgICAgICB7CiAgICAgICAg
ICJzeXN0ZW0iOiAiaXJxX3ZlY3RvcnMiLAogICAgICAgICAibmFtZSI6ICJ2ZWN0b3JfZGVhY3Rp
dmF0ZSIKICAgICAgIH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxIiwKICAgICAg
ICAgIm5hbWUiOiAiaXJxX2hhbmRsZXJfZW50cnkiCiAgICAgICB9LAogICAgICAgewogICAgICAg
ICAic3lzdGVtIjogImlycV92ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAiY2FsbF9mdW5jdGlv
bl9lbnRyeSIKICAgICAgIH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX21hdHJp
eCIsCiAgICAgICAgICJuYW1lIjogImlycV9tYXRyaXhfcmVtb3ZlX3Jlc2VydmVkIgogICAgICAg
fSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJu
YW1lIjogInZlY3Rvcl9yZXNlcnZlX21hbmFnZWQiCiAgICAgICB9LAogICAgICAgewogICAgICAg
ICAic3lzdGVtIjogImlycV92ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAieDg2X3BsYXRmb3Jt
X2lwaV9leGl0IgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfdmVj
dG9ycyIsCiAgICAgICAgICJuYW1lIjogInRoZXJtYWxfYXBpY19lbnRyeSIKICAgICAgIH0sCiAg
ICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX21hdHJpeCIsCiAgICAgICAgICJuYW1lIjog
ImlycV9tYXRyaXhfZnJlZSIKICAgICAgIH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAi
aXJxX3ZlY3RvcnMiLAogICAgICAgICAibmFtZSI6ICJ2ZWN0b3JfZnJlZV9tb3ZlZCIKICAgICAg
IH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3RvcnMiLAogICAgICAgICAi
bmFtZSI6ICJzcHVyaW91c19hcGljX2VudHJ5IgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAg
InN5c3RlbSI6ICJpcnEiLAogICAgICAgICAibmFtZSI6ICJzb2Z0aXJxX2V4aXQiCiAgICAgICB9
LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV92ZWN0b3JzIiwKICAgICAgICAgIm5h
bWUiOiAiY2FsbF9mdW5jdGlvbl9zaW5nbGVfZXhpdCIKICAgICAgIH0sCiAgICAgICB7CiAgICAg
ICAgICJzeXN0ZW0iOiAiaXJxX21hdHJpeCIsCiAgICAgICAgICJuYW1lIjogImlycV9tYXRyaXhf
cmVzZXJ2ZV9tYW5hZ2VkIgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJz
Y2hlZCIsCiAgICAgICAgICJuYW1lIjogInNjaGVkX3dha2luZyIKICAgICAgIH0sCiAgICAgICB7
CiAgICAgICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3RvcnMiLAogICAgICAgICAibmFtZSI6ICJ2ZWN0
b3JfYWxsb2NfbWFuYWdlZCIKICAgICAgIH0sCiAgICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAi
aXJxX3ZlY3RvcnMiLAogICAgICAgICAibmFtZSI6ICJyZXNjaGVkdWxlX2VudHJ5IgogICAgICAg
fSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfbWF0cml4IiwKICAgICAgICAgIm5h
bWUiOiAiaXJxX21hdHJpeF9vZmZsaW5lIgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5
c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJuYW1lIjogInZlY3Rvcl91cGRhdGUiCiAg
ICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV92ZWN0b3JzIiwKICAgICAg
ICAgIm5hbWUiOiAiZXJyb3JfYXBpY19leGl0IgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAg
InN5c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJuYW1lIjogImRlZmVycmVkX2Vycm9y
X2FwaWNfZW50cnkiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV9t
YXRyaXgiLAogICAgICAgICAibmFtZSI6ICJpcnFfbWF0cml4X2Fzc2lnbiIKICAgICAgIH0sCiAg
ICAgICB7CiAgICAgICAgICJzeXN0ZW0iOiAic2NoZWQiLAogICAgICAgICAibmFtZSI6ICJzY2hl
ZF9zd2l0Y2giCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV92ZWN0
b3JzIiwKICAgICAgICAgIm5hbWUiOiAidmVjdG9yX3RlYXJkb3duIgogICAgICAgfSwKICAgICAg
IHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJuYW1lIjogImxv
Y2FsX3RpbWVyX2VudHJ5IgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJz
Y2hlZCIsCiAgICAgICAgICJuYW1lIjogInNjaGVkX3BpX3NldHByaW8iCiAgICAgICB9LAogICAg
ICAgewogICAgICAgICAic3lzdGVtIjogImlycSIsCiAgICAgICAgICJuYW1lIjogImlycV9oYW5k
bGVyX2V4aXQiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV92ZWN0
b3JzIiwKICAgICAgICAgIm5hbWUiOiAiY2FsbF9mdW5jdGlvbl9leGl0IgogICAgICAgfSwKICAg
ICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfbWF0cml4IiwKICAgICAgICAgIm5hbWUiOiAi
aXJxX21hdHJpeF9hc3NpZ25fc3lzdGVtIgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5
c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJuYW1lIjogInZlY3Rvcl9yZXNlcnZlIgog
ICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAg
ICAgICJuYW1lIjogImlycV93b3JrX2VudHJ5IgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAg
InN5c3RlbSI6ICJpcnFfdmVjdG9ycyIsCiAgICAgICAgICJuYW1lIjogInRoZXJtYWxfYXBpY19l
eGl0IgogICAgICAgfSwKICAgICAgIHsKICAgICAgICAgInN5c3RlbSI6ICJzY2hlZCIsCiAgICAg
ICAgICJuYW1lIjogInNjaGVkX3Byb2Nlc3NfZXhpdCIKICAgICAgIH0sCiAgICAgICB7CiAgICAg
ICAgICJzeXN0ZW0iOiAiaXJxX3ZlY3RvcnMiLAogICAgICAgICAibmFtZSI6ICJzcHVyaW91c19h
cGljX2V4aXQiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycSIsCiAg
ICAgICAgICJuYW1lIjogInNvZnRpcnFfcmFpc2UiCiAgICAgICB9LAogICAgICAgewogICAgICAg
ICAic3lzdGVtIjogImlycV92ZWN0b3JzIiwKICAgICAgICAgIm5hbWUiOiAidGhyZXNob2xkX2Fw
aWNfZW50cnkiCiAgICAgICB9LAogICAgICAgewogICAgICAgICAic3lzdGVtIjogImlycV9tYXRy
aXgiLAogICAgICAgICAibmFtZSI6ICJpcnFfbWF0cml4X3JlbW92ZV9tYW5hZ2VkIgogICAgICAg
fQogICAgIF0KICAgfSwKICAgIlBsdWdpbiI6ICJmdW5jdGlvbl9ncmFwaCIsCiAgICJPdXRwdXQi
OiAiXC9yb290XC90cmFjZS10ZXN0LmRhdCIsCiAgICJDb21tYW5kIjogIlwvd29ya1wvY1wvbWln
cmF0ZSIKIH0=

--MP_/wCpN1YMqD+hGPZu/oY67mJF--
