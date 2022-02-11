Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340BDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Feb 2022 12:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350083AbiBKMa0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:30:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiBKMaZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 07:30:25 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C9EF6E
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Feb 2022 04:30:23 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id bx2so16213291edb.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Feb 2022 04:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=RyHS+OO8iPIUZCP+J4LyiS0R6H1nLjM48M37cPuu/UI=;
        b=SsSNnXopGTbbUS/lB0IWTrhPKJY2pIhIlMk5PSkXmIc51OViO/0/0CaAK7gbxzLOEB
         V8MiXi5Pypp6Mcaj2+fpLbakO006pLKVlgcvhueUu1kWfed0Y/tK8dYd/7TAHSQFVEL6
         68J9lm7HjkHDOCAEB6EqzDywEBBG+awkIU9s3mQVIMimuKF6+z2AOApDwyfhKS2GDxKH
         g1RRSeAV6YjKh4xc7bsGMpO202ZLGK162/yMrC1xavf8hU3NDqubrzFlAH0121uNiZCa
         vSOUg+0Ly9yHmfQ6Yj78LQJdSrhuCG4p4zSLPc95VbYQN/KW0bUWPVM79uV8cCC9+y0U
         43Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=RyHS+OO8iPIUZCP+J4LyiS0R6H1nLjM48M37cPuu/UI=;
        b=p1fsWCXnpbuobLctEAowxlwrmWZbGczSrcgMAE7sALvuqD1UXRRBtJkG0kQaGkaV2Z
         3GxqrJsUyZgihvL5MKCIuxOVQlYmKcIFsAQtdGk5zOum+8KUK76PMWj/wsYnmuR8K+HN
         eo+Dchc2rbOMElYisnfVY/+mQeMFgX+cjVJJFIu9Fzog39EjyMvxCZgOTeLmCfzTYxrn
         RJguIUXpn+AoaS4pXv+wsCsFP2f0dSc7J0sYdIt+yaAAAEwABHxTDpIp/2yxEHcRsRoU
         UehEwy+RrEkqqtUZKdv5q+qxRZoEj93c5cSvBvgPdM3auV7Fru/kmL1Kg4/24ZfjJ/zd
         AxTQ==
X-Gm-Message-State: AOAM531lzAsoxBStETyx+kexjGnVlsaXm5bVp1/pQEzltrUwEe7p4hJy
        T5sVxm6FZnL5mibw/tZFy2E=
X-Google-Smtp-Source: ABdhPJz4847DVT71cFKEWx0ztRcp/q+1WhUtYoBrB2GIIRRZJzzsdi7IBs7D33J0ucY0TxIRiTC53w==
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr1636167edd.325.1644582621890;
        Fri, 11 Feb 2022 04:30:21 -0800 (PST)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id ee23sm8969880edb.19.2022.02.11.04.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 04:30:21 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------AY7GZFZx8NL2PK0MgaDc3cWi"
Message-ID: <5c472cb1-c599-dafd-eee5-26a0fca53b3a@gmail.com>
Date:   Fri, 11 Feb 2022 14:30:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH 0/2] Allow GUI plugins to build standalone
Content-Language: en-US
To:     "Chen, Hongzhan" <hongzhan.chen@intel.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
References: <20220119120229.68627-1-y.karadz@gmail.com>
 <27543723-5970-a968-30ab-e30e5731e53a@gmail.com>
 <MN2PR11MB4285CF1156C93679DFDAA5F7F2309@MN2PR11MB4285.namprd11.prod.outlook.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <MN2PR11MB4285CF1156C93679DFDAA5F7F2309@MN2PR11MB4285.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------AY7GZFZx8NL2PK0MgaDc3cWi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11.02.22 г. 7:03 ч., Chen, Hongzhan wrote:
> But when I double click the box , kernel-shark quit abnormally with segmentation fault.
> 
> Following is backtrace info:
> 
> [Thread 0x7fffc084d700 (LWP 2064) exited]
> 
> Thread 1 "kernelshark" received signal SIGSEGV, Segmentation fault.
> KsMainWindow::markEntry (this=0x0, e=0x7fffadf90f60, st=DualMarkerState::B) at /home/intel/iotg/dovetail/kernelshark/kernel-shark/src/KsUtils.hpp:229
> 229             ssize_t size() const {return _dataSize;}
> (gdb) backtrace
> #0  0x00007ffff7b91442 in KsMainWindow::markEntry(kshark_entry const*, DualMarkerState) (this=0x0, e=0x7fffadf90f60, st=DualMarkerState::B)
>      at /home/intel/iotg/dovetail/kernelshark/kernel-shark/src/KsUtils.hpp:229
> #1  0x00007fffc0876329 in XenomaiSwitchBox::_doubleClick() const (this=0x1c7ebc0) at CobaltSwitchEvents.cpp:43
> #2  0x00007ffff5a2594f in QWidget::event(QEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #3  0x00007ffff59e683c in QApplicationPrivate::notify_helper(QObject*, QEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #4  0x00007ffff59ee65f in QApplication::notify(QObject*, QEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #5  0x00007ffff48dc8a8 in QCoreApplication::notifyInternal2(QObject*, QEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
> #6  0x00007ffff59ed632 in QApplicationPrivate::sendMouseEvent(QWidget*, QMouseEvent*, QWidget*, QWidget*, QWidget**, QPointer<QWidget>&, bool) ()
>      at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #7  0x00007ffff5a4015b in  () at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #8  0x00007ffff5a427ca in  () at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #9  0x00007ffff59e683c in QApplicationPrivate::notify_helper(QObject*, QEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #10 0x00007ffff59ee104 in QApplication::notify(QObject*, QEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5
> #11 0x00007ffff48dc8a8 in QCoreApplication::notifyInternal2(QObject*, QEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
> #12 0x00007ffff522a780 in QGuiApplicationPrivate::processMouseEvent(QWindowSystemInterfacePrivate::MouseEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5
> #13 0x00007ffff522c0b5 in QGuiApplicationPrivate::processWindowSystemEvent(QWindowSystemInterfacePrivate::WindowSystemEvent*) () at /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5
> #14 0x00007ffff520333b in QWindowSystemInterface::sendWindowSystemEvents(QFlags<QEventLoop::ProcessEventsFlag>) () at /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5
> #15 0x00007fffed8ae260 in  () at /usr/lib/x86_64-linux-gnu/libQt5XcbQpa.so.5
> #16 0x00007ffff13b7537 in g_main_context_dispatch () at /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0
> #17 0x00007ffff13b7770 in  () at /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0
> #18 0x00007ffff13b77fc in g_main_context_iteration () at /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0
> #19 0x00007ffff493585f in QEventDispatcherGlib::processEvents(QFlags<QEventLoop::ProcessEventsFlag>) () at /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
> #20 0x00007ffff48da8da in QEventLoop::exec(QFlags<QEventLoop::ProcessEventsFlag>) () at /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
> #21 0x00007ffff48e3984 in QCoreApplication::exec() () at /usr/lib/x86_64-linux-gnu/libQt5Core.so.5
> #22 0x0000000000402af5 in main (argc=<optimized out>, argv=<optimized out>) at /home/intel/iotg/dovetail/kernelshark/kernel-shark/src/kernelshark.cpp:154
> #23 0x00007ffff369abf7 in __libc_start_main (main=
>      0x402480 <main>, argc=1, argv=0x7fffffffdd18, init=<optimized out>, fini=<optimized out>, rtld_fini=<optimized out>, stack_end=0x7fffffffdd08) at ../csu/libc-start.c:310
> #24 0x0000000000402cfa in _start () at /home/intel/iotg/dovetail/kernelshark/kernel-shark/src/kernelshark.cpp:129
> (gdb)
> 

Hi Hongzhan,

I have an idea what can be the problem here.
Please try applying the attached patch and let me know if the double click works.

Thanks!
Yordan


> Regards
> 
> Hongzhan Chen
--------------AY7GZFZx8NL2PK0MgaDc3cWi
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-kernel-shark-Load-ctrl-interface-for-user-plugins-Wi.patch"
Content-Disposition: attachment;
 filename*0="0001-kernel-shark-Load-ctrl-interface-for-user-plugins-Wi.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA5Y2FhZjcwNDFkNWY4ODIxZWU3OTAwN2YzNmY5YzQ2NTM2NGVlNTQ4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiAiWW9yZGFuIEthcmFkemhvdiAoVk13YXJlKSIgPHku
a2FyYWR6QGdtYWlsLmNvbT4KRGF0ZTogRnJpLCAxMSBGZWIgMjAyMiAxNDowOTo1NiArMDIw
MApTdWJqZWN0OiBbUEFUQ0hdIGtlcm5lbC1zaGFyazogTG9hZCBjdHJsIGludGVyZmFjZSBm
b3IgdXNlciBwbHVnaW5zIChXaVApCgpTaWduZWQtb2ZmLWJ5OiBZb3JkYW4gS2FyYWR6aG92
IChWTXdhcmUpIDx5LmthcmFkekBnbWFpbC5jb20+Ci0tLQogc3JjL0tzVXRpbHMuY3BwIHwg
MzcgKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQogc3JjL0tzVXRpbHMu
aHBwIHwgIDQgKysrLQogMiBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCAxNSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9zcmMvS3NVdGlscy5jcHAgYi9zcmMvS3NVdGls
cy5jcHAKaW5kZXggYTIyYzQ0NS4uZjYyOTg3YiAxMDA2NDQKLS0tIGEvc3JjL0tzVXRpbHMu
Y3BwCisrKyBiL3NyYy9Lc1V0aWxzLmNwcApAQCAtMTA1NywxMSArMTA1NywxMSBAQCB2b2lk
IEtzRGF0YVN0b3JlOjpzZXRDbG9ja09mZnNldChpbnQgc2QsIGludDY0X3Qgb2Zmc2V0KQog
S3NQbHVnaW5NYW5hZ2VyOjpLc1BsdWdpbk1hbmFnZXIoUVdpZGdldCAqcGFyZW50KQogOiBR
T2JqZWN0KHBhcmVudCkKIHsKLQlfbG9hZFBsdWdpbkxpc3QoS3NVdGlsczo6Z2V0UGx1Z2lu
TGlzdCgpKTsKKwlfbG9hZFBsdWdpbkxpc3QoS3NVdGlsczo6Z2V0UGx1Z2luTGlzdCgpLCBm
YWxzZSk7CiB9CiAKIFFWZWN0b3I8a3NoYXJrX3BsdWdpbl9saXN0ICo+Ci1Lc1BsdWdpbk1h
bmFnZXI6Ol9sb2FkUGx1Z2luTGlzdChjb25zdCBRU3RyaW5nTGlzdCAmcGx1Z2lucykKK0tz
UGx1Z2luTWFuYWdlcjo6X2xvYWRQbHVnaW5MaXN0KGNvbnN0IFFTdHJpbmdMaXN0ICZwbHVn
aW5zLCBib29sIHJlZ0N0cmwpCiB7CiAJa3NoYXJrX2NvbnRleHQgKmtzaGFya19jdHgobnVs
bHB0cik7CiAJUVZlY3Rvcjxrc2hhcmtfcGx1Z2luX2xpc3QgKj4gdmVjOwpAQCAtMTA5MCw4
ICsxMDkwLDExIEBAIEtzUGx1Z2luTWFuYWdlcjo6X2xvYWRQbHVnaW5MaXN0KGNvbnN0IFFT
dHJpbmdMaXN0ICZwbHVnaW5zKQogCQkJCQkJCW5hbWUuY19zdHIoKSwKIAkJCQkJCQlsaWIu
Y19zdHIoKSk7CiAKLQkJCWlmIChwbHVnaW4pCisJCQlpZiAocGx1Z2luKSB7CiAJCQkJdmVj
LmFwcGVuZChwbHVnaW4pOworCQkJCWlmIChyZWdDdHJsKQorCQkJCQlfcmVnaXN0ZXJDdHJs
SW50ZXJmYWNlKHBsdWdpbik7CisJCQl9CiAJCX0KIAl9CiAKQEAgLTExOTAsNiArMTE5Mywx
OSBAQCBRVmVjdG9yPGludD4gS3NQbHVnaW5NYW5hZ2VyOjpnZXRQbHVnaW5zQnlTdGF0dXMo
aW50IHNkLCBpbnQgc3RhdHVzKSBjb25zdAogCXJldHVybiB2ZWM7CiB9CiAKK3ZvaWQgS3NQ
bHVnaW5NYW5hZ2VyOjpfcmVnaXN0ZXJDdHJsSW50ZXJmYWNlKGtzaGFya19wbHVnaW5fbGlz
dCAqcGx1Z2luKQoreworCWlmICghcGx1Z2luLT5oYW5kbGUgfHwgIXBsdWdpbi0+Y3RybF9p
bnRlcmZhY2UpCisJCXJldHVybjsKKworCXZvaWQgKmRpYWxvZ1B0ciA9IHBsdWdpbi0+Y3Ry
bF9pbnRlcmZhY2UocGFyZW50KCkpOworCWlmIChkaWFsb2dQdHIpIHsKKwkJUVdpZGdldCAq
ZGlhbG9nID0gc3RhdGljX2Nhc3Q8UVdpZGdldCAqPihkaWFsb2dQdHIpOworCQlpZiAoX3Bs
dWdpbkRpYWxvZ3MuaW5kZXhPZihkaWFsb2cpIDwgMCkKKwkJCV9wbHVnaW5EaWFsb2dzLmFw
cGVuZChkaWFsb2cpOworCX0KK30KKwogLyoqCiAgKiBAYnJpZWYgTG9vcCBvdmVyIHRoZSBy
ZWdpc3RlcmVkIHBsdWdpbnMgYW5kIHJlZ2lzdGVyIGFsbCBwbHVnaW4tZGVmaW5lZAogICoJ
ICBtZW51cyAoaWYgYW55KS4KQEAgLTEyMDMsMTQgKzEyMTksNyBAQCB2b2lkIEtzUGx1Z2lu
TWFuYWdlcjo6cmVnaXN0ZXJQbHVnaW5NZW51ZXMoKQogCQlyZXR1cm47CiAKIAlmb3IgKHBs
dWdpbiA9IGtzaGFya19jdHgtPnBsdWdpbnM7IHBsdWdpbjsgcGx1Z2luID0gcGx1Z2luLT5u
ZXh0KQotCQlpZiAocGx1Z2luLT5oYW5kbGUgJiYgcGx1Z2luLT5jdHJsX2ludGVyZmFjZSkg
ewotCQkJdm9pZCAqZGlhbG9nUHRyID0gcGx1Z2luLT5jdHJsX2ludGVyZmFjZShwYXJlbnQo
KSk7Ci0JCQlpZiAoZGlhbG9nUHRyKSB7Ci0JCQkJUVdpZGdldCAqZGlhbG9nID0KLQkJCQkJ
c3RhdGljX2Nhc3Q8UVdpZGdldCAqPihkaWFsb2dQdHIpOwotCQkJCV9wbHVnaW5EaWFsb2dz
LmFwcGVuZChkaWFsb2cpOwotCQkJfQotCQl9CisJCV9yZWdpc3RlckN0cmxJbnRlcmZhY2Uo
cGx1Z2luKTsKIH0KIAogc3RkOjpzdHJpbmcgS3NQbHVnaW5NYW5hZ2VyOjpfcGx1Z2luTGli
RnJvbU5hbWUoY29uc3QgUVN0cmluZyAmcGx1Z2luKQpAQCAtMTI0NywxMSArMTI1NiwxMSBA
QCBzdGQ6OnN0cmluZyBLc1BsdWdpbk1hbmFnZXI6Ol9wbHVnaW5OYW1lRnJvbUxpYihjb25z
dCBRU3RyaW5nICZwbHVnaW4pCiAgKiBAcGFyYW0gcGx1Z2luTmFtZXM6IFByb3ZpZGUgaGVy
ZSB0aGUgbmFtZXMgb2YgdGhlIHBsdWdpbiAoYXMgaW4gdGhlCiAgKgkJICAgICAgIENNYWtl
LWdlbmVyYXRlZCBoZWFkZXIgZmlsZSkgb3IgdGhlIG5hbWVzIG9mIHRoZQogICoJCSAgICAg
ICBwbHVnaW4ncyBsaWJyYXJ5IGZpbGVzICguc28gaW5jbHVkaW5nIHBhdGgpLgotICogCQkg
ICAgICAgVGhlIG5hbWVzIG11c3QgYmUgY29tbWEgc2VwYXJhdGVkLgorICoJCSAgICAgICBU
aGUgbmFtZXMgbXVzdCBiZSBjb21tYSBzZXBhcmF0ZWQuCiAgKi8KIHZvaWQgS3NQbHVnaW5N
YW5hZ2VyOjpyZWdpc3RlclBsdWdpbnMoY29uc3QgUVN0cmluZyAmcGx1Z2luTmFtZXMpCiB7
Ci0JX3VzZXJQbHVnaW5zLmFwcGVuZChfbG9hZFBsdWdpbkxpc3QocGx1Z2luTmFtZXMuc3Bs
aXQoJywnKSkpOworCV91c2VyUGx1Z2lucy5hcHBlbmQoX2xvYWRQbHVnaW5MaXN0KHBsdWdp
bk5hbWVzLnNwbGl0KCcsJyksIHRydWUpKTsKIH0KIAogLyoqCkBAIC0xMzY4LDcgKzEzNzcs
NyBAQCB2b2lkIEtzUGx1Z2luTWFuYWdlcjo6YWRkUGx1Z2lucyhjb25zdCBRU3RyaW5nTGlz
dCAmZmlsZU5hbWVzLAogCWlmICgha3NoYXJrX2luc3RhbmNlKCZrc2hhcmtfY3R4KSkKIAkJ
cmV0dXJuOwogCi0JcGx1Z2lucyA9IF9sb2FkUGx1Z2luTGlzdChmaWxlTmFtZXMpOworCXBs
dWdpbnMgPSBfbG9hZFBsdWdpbkxpc3QoZmlsZU5hbWVzLCB0cnVlKTsKIAlfdXNlclBsdWdp
bnMuYXBwZW5kKHBsdWdpbnMpOwogCiAJaWYgKHN0cmVhbUlkcy5pc0VtcHR5KCkpCmRpZmYg
LS1naXQgYS9zcmMvS3NVdGlscy5ocHAgYi9zcmMvS3NVdGlscy5ocHAKaW5kZXggMWE5N2Q5
ZS4uZWM1OGM0NCAxMDA2NDQKLS0tIGEvc3JjL0tzVXRpbHMuaHBwCisrKyBiL3NyYy9Lc1V0
aWxzLmhwcApAQCAtMzI4LDcgKzMyOCw5IEBAIHByaXZhdGU6CiAJUVZlY3RvcjxRV2lkZ2V0
ICo+CQlfcGx1Z2luRGlhbG9nczsKIAogCVFWZWN0b3I8a3NoYXJrX3BsdWdpbl9saXN0ICo+
Ci0JX2xvYWRQbHVnaW5MaXN0KGNvbnN0IFFTdHJpbmdMaXN0ICZwbHVnaW5zKTsKKwlfbG9h
ZFBsdWdpbkxpc3QoY29uc3QgUVN0cmluZ0xpc3QgJnBsdWdpbnMsIGJvb2wgcmVnQ3RybCk7
CisKKwl2b2lkIF9yZWdpc3RlckN0cmxJbnRlcmZhY2Uoa3NoYXJrX3BsdWdpbl9saXN0ICpw
bHVnaW4pOwogCiAJc3RkOjpzdHJpbmcgX3BsdWdpbkxpYkZyb21OYW1lKGNvbnN0IFFTdHJp
bmcgJnBsdWdpbik7CiAKLS0gCjIuMzIuMAoK

--------------AY7GZFZx8NL2PK0MgaDc3cWi--
