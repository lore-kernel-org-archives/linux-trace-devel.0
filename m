Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520F8C10F1E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 16:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiLTQvJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 11:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLTQvI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 11:51:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A21B1CE
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 08:51:06 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jo4so21698923ejb.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 08:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:from:references:to:content-language:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4cmcqHmqap4BhJzoWao5t065lzNu5XpGdhSu7+7Bu7k=;
        b=ADsiir+jvcNg2+FQ4DqzaOEC6nZw+TBfandAJjw2P/ZlrndxEkpLRlcpuVr4qEN6vW
         U7pzbgdc+TX/YOze8O4fBdlnet6Cq82eBvmDoz/96Oh2b+LFf9h5YXZdZFBO9pXESWmL
         1IHudKimDqdNml0yD+flLGDhwLn6UPb6FPnuDGVOTPv/ciH0tB6OmBmnnwfF65u3DvN4
         1nxsCEjBeT7SN6bFgFqEBK5HII9e7D5RwsE0fX8jML4TK4R3o+C5n9BO/LIMxdodm0PL
         lLLmiGmBtPUfV2EPK66WIr9AHnrCwuLyMTk8j8qr9zubclBsEqtm//KmI3g0frgbO45U
         9HjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:to:content-language:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4cmcqHmqap4BhJzoWao5t065lzNu5XpGdhSu7+7Bu7k=;
        b=jZTrY8QOd+2sgC90HV8qGPz+UsH23oLP0SOzCuk4DIMg0OFScImwTG6wXq76c0hH8Q
         +/4r2cW5nP9Xl7PrWOR3ycDY7nGeYBK9EkAsF3/tYhqFNs5ooPWN+JKgNe3GiYWUGgmp
         xBdjnrcrnfRlAvYxAfGPnW1/5mUFdp2ZA+V21E44OgEz5JIy0xGWQ5FKU78+gCYnmwSk
         9TbvB4K77pMhC2U8SmHWTDCm2fK0juPETHB4x7x0ROxkCb9yz1YGSMlHp/r1Osa4+Kc3
         AiFVWIfZCDkhvSf8dut4tYdrkrijP/xbC/Z0e7NCBco+ZJwmBROlkHX6f0Ai6LVLg7NN
         Xukw==
X-Gm-Message-State: ANoB5pnGzsVR4ZVigF5miIDaZBCXEuB6Yaz0GiDBFk2dIsJcJF0Djx76
        u5Vzx9f/bct5RLJH+u5q6qHirpqEOt0=
X-Google-Smtp-Source: AA0mqf6GA7xH5J2c8J+myicz5UOn3wDG1ydyw5cQD1FNydXLhORiPWwGyQPryUA8HgUPlaXqvN5aDw==
X-Received: by 2002:a17:906:164d:b0:7ad:e255:9238 with SMTP id n13-20020a170906164d00b007ade2559238mr38523812ejd.21.1671555065037;
        Tue, 20 Dec 2022 08:51:05 -0800 (PST)
Received: from [192.168.0.101] (78-154-14-113.ip.btc-net.bg. [78.154.14.113])
        by smtp.gmail.com with ESMTPSA id kw16-20020a170907771000b007ba46867e6asm6002291ejc.16.2022.12.20.08.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 08:51:04 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------soG2ORCt6pDdf8nLb7yfoxpA"
Message-ID: <4470bb69-1558-5775-67ff-9b6b0779f573@gmail.com>
Date:   Tue, 20 Dec 2022 18:51:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] kernel-shark: Show multi-line events in quick view
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20221214154643.43a4e137@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20221214154643.43a4e137@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------soG2ORCt6pDdf8nLb7yfoxpA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/14/22 22:46, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Some events (stack traces) have multiple lines, but the list view of each
> event is just a single line. To get the content of the full event, if the
> user selects the right mouse button over the event to trigger the quick
> view, display the entire content of the event.
> 
Hi Steven

I wonder if the context menu is the best place to display those 
multi-line events. This menu is quite busy already and if you want to 
check a number of events, each time you have to open it then close it 
and reopen it again in order to see the next event. I think this can be 
a bit annoying.

An alternative can be to use the dual marker. For example we can make it 
to work such that all lines of the event selected with the markers are 
shown directly into the table.

I am attaching a RFC patch that that implements this. Note that I didn't 
time to fully test and debug this for all corner cases, but it should 
work at leas for the most straight-forward  use case. Please try it and 
tell me what you think.

Thanks!
Y.

> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>   src/KsQuickContextMenu.cpp | 9 +++++++++
>   src/KsQuickContextMenu.hpp | 2 +-
>   2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/src/KsQuickContextMenu.cpp b/src/KsQuickContextMenu.cpp
> index 6fa242de348d..cc714bfb1aae 100644
> --- a/src/KsQuickContextMenu.cpp
> +++ b/src/KsQuickContextMenu.cpp
> @@ -52,6 +52,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDualMarkerSM *dm,
>     _row(row),
>     _rawTime(this),
>     _rawEvent(this),
> +  _eventInfo(this),
>     _graphSyncCBox(nullptr),
>     _listSyncCBox(nullptr),
>     _hideTaskAction(this),
> @@ -104,6 +105,14 @@ KsQuickContextMenu::KsQuickContextMenu(KsDualMarkerSM *dm,
>   		evtData += field + ":  " + val.setNum(fieldVal) + "\n\t";
>   	}
>   
> +	QString evtInfo("\t");
> +	evtInfo += kshark_get_info(entry);
> +	evtInfo += "\n";
> +
> +	addSection("Event info");
> +	_eventInfo.setDefaultWidget(new QLabel(evtInfo));
> +	addAction(&_eventInfo);
> +
>   	addSection("Raw event");
>   	time = QString("\ttime:  %1 [ns]").arg(entry->ts);
>   
> diff --git a/src/KsQuickContextMenu.hpp b/src/KsQuickContextMenu.hpp
> index ca0b341dd363..c07c1a534d3a 100644
> --- a/src/KsQuickContextMenu.hpp
> +++ b/src/KsQuickContextMenu.hpp
> @@ -91,7 +91,7 @@ private:
>   
>   	size_t		_row;
>   
> -	QWidgetAction	_rawTime, _rawEvent;
> +	QWidgetAction	_rawTime, _rawEvent, _eventInfo;
>   
>   	QCheckBox	*_graphSyncCBox, *_listSyncCBox;
>   
--------------soG2ORCt6pDdf8nLb7yfoxpA
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-kernel-shark-Show-multi-line-events-using-the-dual-m.patch"
Content-Disposition: attachment;
 filename*0="0001-kernel-shark-Show-multi-line-events-using-the-dual-m.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA5OWJjZTA4MmZmMDhiMmZiNGNhMjBhNGY2YmZjMzJlZTA0M2YyM2RjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBZb3JkYW4gS2FyYWR6aG92IDx5LmthcmFkekBnbWFp
bC5jb20+CkRhdGU6IFR1ZSwgMjAgRGVjIDIwMjIgMTg6NDU6MzAgKzAyMDAKU3ViamVjdDog
W1JGQyBQQVRDSF0ga2VybmVsLXNoYXJrOiBTaG93IG11bHRpLWxpbmUgZXZlbnRzIHVzaW5n
IHRoZSBkdWFsCiBtYXJrZXIKClNpZ25lZC1vZmYtYnk6IFlvcmRhbiBLYXJhZHpob3YgPHku
a2FyYWR6QGdtYWlsLmNvbT4KLS0tCiBzcmMvS3NUcmFjZVZpZXdlci5jcHAgfCAxOCArKysr
KysrKysrKysrKysrKy0KIHNyYy9Lc1RyYWNlVmlld2VyLmhwcCB8ICAyICsrCiAyIGZpbGVz
IGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9zcmMvS3NUcmFjZVZpZXdlci5jcHAgYi9zcmMvS3NUcmFjZVZpZXdlci5jcHAKaW5kZXgg
YmUwYTQxOS4uOTdjYWFhMCAxMDA2NDQKLS0tIGEvc3JjL0tzVHJhY2VWaWV3ZXIuY3BwCisr
KyBiL3NyYy9Lc1RyYWNlVmlld2VyLmNwcApAQCAtMTEwLDYgKzExMCwyMCBAQCBLc1RyYWNl
Vmlld2VyOjpLc1RyYWNlVmlld2VyKFFXaWRnZXQgKnBhcmVudCkKIAljb25uZWN0KCZfc2Vh
cmNoRlNNLl9zZWFyY2hSZXN0YXJ0QnV0dG9uLAkmUVB1c2hCdXR0b246OnByZXNzZWQsCiAJ
CXRoaXMsCQkJCSZLc1RyYWNlVmlld2VyOjpfc2VhcmNoQ29udGludWUpOwogCisJaW50IGRl
ZmF1bHRSb3dIZWlnaHQgPSBGT05UX0hFSUdIVCAqIDEuMjU7CisJYXV0byBsYW1TZWxlY3Rp
b25DaGFuZ2VkID0gW3RoaXMsIGRlZmF1bHRSb3dIZWlnaHRdKGNvbnN0IFFJdGVtU2VsZWN0
aW9uICZzZWxlY3RlZCwgY29uc3QgUUl0ZW1TZWxlY3Rpb24gJmRlc2VsZWN0ZWQpIHsKKwkg
ICAgaWYgKGRlc2VsZWN0ZWQuY291bnQoKSAmJgorCQlkZXNlbGVjdGVkLmluZGV4ZXMoKS5m
aXJzdCgpLnJvdygpICE9IF9tU3RhdGUtPnBhc3NpdmVNYXJrZXIoKS5fcG9zKSB7CisJCV92
aWV3LnZlcnRpY2FsSGVhZGVyKCktPnJlc2l6ZVNlY3Rpb24oZGVzZWxlY3RlZC5pbmRleGVz
KCkuZmlyc3QoKS5yb3coKSwKKwkJCQkJCSAgICAgIGRlZmF1bHRSb3dIZWlnaHQpOworCSAg
ICB9CisJICAgIGlmIChzZWxlY3RlZC5jb3VudCgpKSB7CisJCV92aWV3LnJlc2l6ZVJvd1Rv
Q29udGVudHMoc2VsZWN0ZWQuaW5kZXhlcygpLmZpcnN0KCkucm93KCkpOworCSAgICB9CisJ
fTsKKwljb25uZWN0KCZfc2VsZWN0aW9uTW9kZWwsCSZRSXRlbVNlbGVjdGlvbk1vZGVsOjpz
ZWxlY3Rpb25DaGFuZ2VkLAorCQlsYW1TZWxlY3Rpb25DaGFuZ2VkKTsKKwogCV9zZWFyY2hG
U00ucGxhY2VJblRvb2xCYXIoJl90b29sYmFyKTsKIAogCS8qCkBAIC0xMjgsMTMgKzE0Miwx
NSBAQCBLc1RyYWNlVmlld2VyOjpLc1RyYWNlVmlld2VyKFFXaWRnZXQgKnBhcmVudCkKIAlf
dmlldy5zZXRFZGl0VHJpZ2dlcnMoUUFic3RyYWN0SXRlbVZpZXc6Ok5vRWRpdFRyaWdnZXJz
KTsKIAlfdmlldy5zZXRTZWxlY3Rpb25CZWhhdmlvcihRQWJzdHJhY3RJdGVtVmlldzo6U2Vs
ZWN0Um93cyk7CiAJX3ZpZXcuc2V0U2VsZWN0aW9uTW9kZShRQWJzdHJhY3RJdGVtVmlldzo6
U2luZ2xlU2VsZWN0aW9uKTsKLQlfdmlldy52ZXJ0aWNhbEhlYWRlcigpLT5zZXREZWZhdWx0
U2VjdGlvblNpemUoRk9OVF9IRUlHSFQgKiAxLjI1KTsKKwlfdmlldy52ZXJ0aWNhbEhlYWRl
cigpLT5zZXREZWZhdWx0U2VjdGlvblNpemUoZGVmYXVsdFJvd0hlaWdodCk7CiAJX3ZpZXcu
c2V0Rm9udChRRm9udERhdGFiYXNlOjpzeXN0ZW1Gb250KFFGb250RGF0YWJhc2U6OkZpeGVk
Rm9udCkpOwogCV92aWV3Lmhvcml6b250YWxIZWFkZXIoKS0+c2V0Rm9udCgKIAkJUUZvbnRE
YXRhYmFzZTo6c3lzdGVtRm9udChRRm9udERhdGFiYXNlOjpHZW5lcmFsRm9udCkpOwogCiAJ
IF9wcm94eU1vZGVsLnNldFNvdXJjZSgmX21vZGVsKTsKKwlfc2VsZWN0aW9uTW9kZWwuc2V0
TW9kZWwoJl9wcm94eU1vZGVsKTsKIAlfdmlldy5zZXRNb2RlbCgmX3Byb3h5TW9kZWwpOwor
CV92aWV3LnNldFNlbGVjdGlvbk1vZGVsKCZfc2VsZWN0aW9uTW9kZWwpOwogCWNvbm5lY3Qo
Jl9wcm94eU1vZGVsLCAmUUFic3RyYWN0SXRlbU1vZGVsOjptb2RlbFJlc2V0LAogCQl0aGlz
LCAmS3NUcmFjZVZpZXdlcjo6X3NlYXJjaFJlc2V0KTsKIApkaWZmIC0tZ2l0IGEvc3JjL0tz
VHJhY2VWaWV3ZXIuaHBwIGIvc3JjL0tzVHJhY2VWaWV3ZXIuaHBwCmluZGV4IGYzOTc5YTYu
LmFlMTkyOWQgMTAwNjQ0Ci0tLSBhL3NyYy9Lc1RyYWNlVmlld2VyLmhwcAorKysgYi9zcmMv
S3NUcmFjZVZpZXdlci5ocHAKQEAgLTEwNiw2ICsxMDYsOCBAQCBwcml2YXRlOgogCiAJS3NG
aWx0ZXJQcm94eU1vZGVsCV9wcm94eU1vZGVsOwogCisJUUl0ZW1TZWxlY3Rpb25Nb2RlbCAJ
X3NlbGVjdGlvbk1vZGVsOworCiAJUVRvb2xCYXIJX3Rvb2xiYXI7CiAKIAlRTGFiZWwJCV9s
YWJlbFNlYXJjaCwgX2xhYmVsR3JGb2xsb3dzOwotLSAKMi4zNy4zCgo=

--------------soG2ORCt6pDdf8nLb7yfoxpA--
