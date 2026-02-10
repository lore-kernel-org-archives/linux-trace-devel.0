Received: from smtpcmd01-sp1.aruba.it (smtpcmd01-sp1.aruba.it [62.149.158.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB72F4FA
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Feb 2026 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770746663; cv=none; b=SzuG+usayw7mh/u2NvGw1ueGkdnMvuJloTGB6ByY0NYjnCAdmP+nNPPnlsScCnci6bzlGrjXpI1c+yKs+wuAI34RAEJRqdguJfK/zWMyEuhONJ59/Q+cWC30TZTSpgr3ww29cSKPKUT3vs3K3VLfQkBQ2Me2XlMd0aCVWUHEbNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770746663; c=relaxed/simple;
	bh=LuW92WQ632JkuU68lkNBwO+oxWU1vFdBNgbepeSRw18=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=GymrWXGMaFmubyTcEhUUysH5SAhVKHLfX+gsgQo2hommdn7+zZpU1a1GguhGNZgwZpC58oXqWdDi32zSM/6WU2FfLXNlcZd5cKxjSXg51rA/e5fSnDEan2cAaWY6wGwAfVFWpPaQwGSGb/Hiot26KIG79YwdZQIE6iYjZ/EJZGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com; spf=pass smtp.mailfrom=benettiengineering.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=mkvzKea0; arc=none smtp.client-ip=62.149.158.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="mkvzKea0"
Received: from [192.168.50.220] ([84.33.84.190])
	by Aruba SMTP with ESMTPSA
	id ps2wvNaDKnDG4ps2xvbQQl; Tue, 10 Feb 2026 19:01:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1770746471; bh=LuW92WQ632JkuU68lkNBwO+oxWU1vFdBNgbepeSRw18=;
	h=Content-Type:Date:MIME-Version:Subject:To:From;
	b=mkvzKea0lcfbxO1rsGB198XYILab3OZWJFjg29s16+acW7YMYy8dkHgaeKGCsvg/v
	 csHSmjd1oklgZ1fCEZdBLj8G+gRLiMPajwHbJPoQLdKevw5HfdltY704ItjD8Pf7m2
	 q53F2hbaLITPCZIgGlMghs94NHkX8kQwKZ3v6TA5kuMOOFZv1yiGlSolBmiPdGvGHR
	 Sllaj2DuxuAKvcm+gdNVHqCqE725el8ZO1+NzXk3wYraIRFaZYH03bxmSytSSsC1iW
	 JlWrbM0gdpY94Wb2Tc+AYaAYGibJc+DNdJkG80WVverbtMpxydJxuuMRGCXdF3vGO1
	 TqjPkeSi0L4/Q==
Content-Type: multipart/mixed; boundary="------------iA6saKj2C0zdqgTDp9kwVcVT"
Message-ID: <e04863f1-3dba-4591-8a85-5e0592c83dba@benettiengineering.com>
Date: Tue, 10 Feb 2026 19:01:10 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Build failure bft for trace-cmd and libtraceevent
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20260208170123.37d468a0@robin>
 <406EA18E-BDD3-4204-A58F-B7F04450FA9F@benettiengineering.com>
 <20260208172234.3a181553@robin>
Content-Language: en-US
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
In-Reply-To: <20260208172234.3a181553@robin>
X-CMAE-Envelope: MS4xfHJP1RxYK3o2jXQoEMFyogGNaPVjyFcAA3oFSG8552yzoDTrmLPPwhAOnFLEazaKx45pzQ95xoMqyUXJbhCJTX4iMJ8KbFKRk+ESko/TpEdJrDWTX2X4
 EUvdtfkdFX6aGBxkJTcUJw1AvIHN9Nvd6lNBL7zSKbE0XSxFpigg4e6y5ICSTz9jomiwryJ8ukyFwgorlboCMOrxjnvy0liGUc46TCllLCLHh7jSkX0wv9px
 YRJlGlojT9xyF9PDyVGa4xnyqFzDKz5JeCXDrT+z1sM=

This is a multi-part message in MIME format.
--------------iA6saKj2C0zdqgTDp9kwVcVT
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Steve,

On 2/8/26 23:22, Steven Rostedt wrote:
> On Sun, 8 Feb 2026 23:14:32 +0100
> Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:
> 
>> Oh, ok. I’m going to follow that commit and add btf option to disable btf to trace-cmd too.
>> At the moment it only checks for libtraceevent version and that won’t be sufficient.
> 
> I don't think you need to change trace-cmd. We can just make the
> tep_btf_print_args() just print the arguments passed in if it is not
> supported,

it is not that clear to me here

> and have the list_args just fail.

Ok.

Attached you find a patch to be tested.

Giulio

> 
> Here's an update to the libtraceevent Makefile to do this. Will need
> something similar for the meson build.
> 
> -- Steve
> 
> diff --git a/Makefile b/Makefile
> index e1a10a02a560..bd88a981d373 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -27,6 +27,13 @@ $(call allow-override,PKG_CONFIG,pkg-config)
>   $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
>   $(call allow-override,LDCONFIG,ldconfig)
>   
> +# Set compile option CFLAGS
> +ifdef EXTRA_CFLAGS
> +  CFLAGS ?= $(EXTRA_CFLAGS)
> +else
> +  CFLAGS ?= -g -Wall
> +endif
> +
>   EXT = -std=gnu99
>   INSTALL = install
>   
> @@ -37,6 +44,20 @@ INSTALL = install
>   DESTDIR ?=
>   DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
>   
> +test-build = $(if $(shell sh -c 'echo "$(1)" | tee /tmp/t.c| \
> +	$(CC) -o /dev/null -x c - > /dev/null 2>&1 && echo y'), $2)
> +
> +define BTF_LATEST_SOURCE
> +#include <linux/btf.h>
> +int main(void) { return BTF_KIND_ENUM64; }
> +endef
> +
> +BTF_OK := $(call test-build,$(BTF_LATEST_SOURCE),y)
> +
> +ifneq ($(strip $(BTF_OK)), y)
> +CFLAGS += -DNO_BTF
> +endif
> +
>   LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
>   ifeq ($(LP64), 1)
>     libdir_relative_temp = lib64
> @@ -123,13 +144,6 @@ INCLUDES = -I. -I $(srctree)/include -I $(EP_HEADERS_DIR) $(CONFIG_INCLUDES)
>   
>   export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED EP_HEADERS_DIR
>   
> -# Set compile option CFLAGS
> -ifdef EXTRA_CFLAGS
> -  CFLAGS := $(EXTRA_CFLAGS)
> -else
> -  CFLAGS := -g -Wall
> -endif
> -
>   LIBS ?= -ldl
>   export LIBS
>   

--------------iA6saKj2C0zdqgTDp9kwVcVT
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Fix-build-failure-due-to-btf-on-Linux-6.0.patch"
Content-Disposition: attachment;
 filename="0001-Fix-build-failure-due-to-btf-on-Linux-6.0.patch"
Content-Transfer-Encoding: base64

RnJvbSBlMTQxMzllNjNiNjhlY2NkMjgwMDQwNmM0ZjVhZDA0OTAxNWE4Y2Y2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBHaXVsaW8gQmVuZXR0aSA8Z2l1bGlvLmJlbmV0dGlA
YmVuZXR0aWVuZ2luZWVyaW5nLmNvbT4KRGF0ZTogVHVlLCAxMCBGZWIgMjAyNiAxNzo1Nzo1
MiArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIEZpeCBidWlsZCBmYWlsdXJlIGR1ZSB0byBidGYg
b24gTGludXggPCA2LjAKCldpdGggY29tbWl0OgpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD02
MDg5ZmIzMjVjZjczN2VlYjJjNGQyMzZjOTQ2OTcxMTJjYTg2MGRhCmVudW0gQlRGX0tJTkRf
RU5VTTY0IGhhcyBiZWVuIGZpcnN0bHkgaW50cm9kdWNlZCBhbmQgdGhpcyBpcyB0aGUgbGF0
ZXN0CkJURl9LSU5EXyogZW51bWFyYXRpb24gdG8gYmUgYWRkZWQgdG8gbGlidHJhY2VldmVu
dC4gU28gbGV0J3MgY2hlY2sKaW4gcnVudGltZSwgYm90aCBpbiBNYWtlZmlsZSBhbmQgbWVz
b24sIGlmIEJURl9LSU5EX0VOVU02NCBkb2VzIGV4aXN0LgpJZiBpdCdzIG5vdCB0aGVyZSBs
ZXQncyBkaXNhYmxlIGJ0ZiBzdXBwb3J0LgoKU2lnbmVkLW9mZi1ieTogU3RldmVuIFJvc3Rl
ZHQgKEdvb2dsZSkgPHJvc3RlZHRAZ29vZG1pcy5vcmc+CkNvLWF1dGhvcmVkLWJ5OiBHaXVs
aW8gQmVuZXR0aSA8Z2l1bGlvLmJlbmV0dGlAYmVuZXR0aWVuZ2luZWVyaW5nLmNvbT4KU2ln
bmVkLW9mZi1ieTogR2l1bGlvIEJlbmV0dGkgPGdpdWxpby5iZW5ldHRpQGJlbmV0dGllbmdp
bmVlcmluZy5jb20+Ci0tLQogTWFrZWZpbGUgICAgICAgIHwgMjggKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLQogc3JjL21lc29uLmJ1aWxkIHwgMTIgKysrKysrKysrKysrCiBzcmMv
dHJhY2UtYnRmLmMgfCAgOSArKysrKysrKysKIDMgZmlsZXMgY2hhbmdlZCwgNDIgaW5zZXJ0
aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2Vm
aWxlCmluZGV4IGUxYTEwYTAuLmJkODhhOTggMTAwNjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBi
L01ha2VmaWxlCkBAIC0yNyw2ICsyNywxMyBAQCAkKGNhbGwgYWxsb3ctb3ZlcnJpZGUsUEtH
X0NPTkZJRyxwa2ctY29uZmlnKQogJChjYWxsIGFsbG93LW92ZXJyaWRlLExEX1NPX0NPTkZf
UEFUSCwvZXRjL2xkLnNvLmNvbmYuZC8pCiAkKGNhbGwgYWxsb3ctb3ZlcnJpZGUsTERDT05G
SUcsbGRjb25maWcpCiAKKyMgU2V0IGNvbXBpbGUgb3B0aW9uIENGTEFHUworaWZkZWYgRVhU
UkFfQ0ZMQUdTCisgIENGTEFHUyA/PSAkKEVYVFJBX0NGTEFHUykKK2Vsc2UKKyAgQ0ZMQUdT
ID89IC1nIC1XYWxsCitlbmRpZgorCiBFWFQgPSAtc3RkPWdudTk5CiBJTlNUQUxMID0gaW5z
dGFsbAogCkBAIC0zNyw2ICs0NCwyMCBAQCBJTlNUQUxMID0gaW5zdGFsbAogREVTVERJUiA/
PQogREVTVERJUl9TUSA9ICckKHN1YnN0ICcsJ1wnJywkKERFU1RESVIpKScKIAordGVzdC1i
dWlsZCA9ICQoaWYgJChzaGVsbCBzaCAtYyAnZWNobyAiJCgxKSIgfCB0ZWUgL3RtcC90LmN8
IFwKKwkkKENDKSAtbyAvZGV2L251bGwgLXggYyAtID4gL2Rldi9udWxsIDI+JjEgJiYgZWNo
byB5JyksICQyKQorCitkZWZpbmUgQlRGX0xBVEVTVF9TT1VSQ0UKKyNpbmNsdWRlIDxsaW51
eC9idGYuaD4KK2ludCBtYWluKHZvaWQpIHsgcmV0dXJuIEJURl9LSU5EX0VOVU02NDsgfQor
ZW5kZWYKKworQlRGX09LIDo9ICQoY2FsbCB0ZXN0LWJ1aWxkLCQoQlRGX0xBVEVTVF9TT1VS
Q0UpLHkpCisKK2lmbmVxICgkKHN0cmlwICQoQlRGX09LKSksIHkpCitDRkxBR1MgKz0gLURO
T19CVEYKK2VuZGlmCisKIExQNjQgOj0gJChzaGVsbCBlY2hvIF9fTFA2NF9fIHwgJHtDQ30g
JHtDRkxBR1N9IC1FIC14IGMgLSB8IHRhaWwgLW4gMSkKIGlmZXEgKCQoTFA2NCksIDEpCiAg
IGxpYmRpcl9yZWxhdGl2ZV90ZW1wID0gbGliNjQKQEAgLTEyMywxMyArMTQ0LDYgQEAgSU5D
TFVERVMgPSAtSS4gLUkgJChzcmN0cmVlKS9pbmNsdWRlIC1JICQoRVBfSEVBREVSU19ESVIp
ICQoQ09ORklHX0lOQ0xVREVTKQogCiBleHBvcnQgTElCVFJBQ0VFVkVOVF9TVEFUSUMgTElC
VFJBQ0VFVkVOVF9TSEFSRUQgRVBfSEVBREVSU19ESVIKIAotIyBTZXQgY29tcGlsZSBvcHRp
b24gQ0ZMQUdTCi1pZmRlZiBFWFRSQV9DRkxBR1MKLSAgQ0ZMQUdTIDo9ICQoRVhUUkFfQ0ZM
QUdTKQotZWxzZQotICBDRkxBR1MgOj0gLWcgLVdhbGwKLWVuZGlmCi0KIExJQlMgPz0gLWxk
bAogZXhwb3J0IExJQlMKIApkaWZmIC0tZ2l0IGEvc3JjL21lc29uLmJ1aWxkIGIvc3JjL21l
c29uLmJ1aWxkCmluZGV4IDNhN2EwODIuLjIzYjQzZmYgMTAwNjQ0Ci0tLSBhL3NyYy9tZXNv
bi5idWlsZAorKysgYi9zcmMvbWVzb24uYnVpbGQKQEAgLTE3LDYgKzE3LDE4IEBAIHNvdXJj
ZXM9IFsKIGNjID0gbWVzb24uZ2V0X2NvbXBpbGVyKCdjJykKIGRsX2RlcCA9IGNjLmZpbmRf
bGlicmFyeSgnZGwnKQogCitidGZfZW51bTY0X3Rlc3RfY29kZSA9ICcnJworI2luY2x1ZGUg
PGxpbnV4L2J0Zi5oPgoraW50IG1haW4odm9pZCkgeworICAgIGludCB4ID0gQlRGX0tJTkRf
RU5VTTY0OworICAgIHJldHVybiAwOworfQorJycnCisKK2lmIGNjLmNvbXBpbGVzKGJ0Zl9l
bnVtNjRfdGVzdF9jb2RlLCBuYW1lIDogJ0JURl9LSU5EX0VOVU02NCBjaGVjaycpCisgICAg
YWRkX3Byb2plY3RfYXJndW1lbnRzKCctRE5PX0JURicsIGxhbmd1YWdlIDogJ2MnKQorZW5k
aWYKKwogbGlidHJhY2VldmVudCA9IGxpYnJhcnkoCiAgICAgJ3RyYWNlZXZlbnQnLAogICAg
IHNvdXJjZXMsCmRpZmYgLS1naXQgYS9zcmMvdHJhY2UtYnRmLmMgYi9zcmMvdHJhY2UtYnRm
LmMKaW5kZXggODU5YjA4Ni4uYzcxMDJkOCAxMDA2NDQKLS0tIGEvc3JjL3RyYWNlLWJ0Zi5j
CisrKyBiL3NyYy90cmFjZS1idGYuYwpAQCAtNDcxLDYgKzQ3MSw5IEBAIHN0YXRpYyBpbnQg
aW5pdF9idGZfZnVuYyhzdHJ1Y3QgdGVwX2J0ZiAqYnRmLCBzdHJ1Y3QgdHJhY2Vfc2VxICpz
LAogICovCiBpbnQgdGVwX2J0Zl9saXN0X2FyZ3Moc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwg
c3RydWN0IHRyYWNlX3NlcSAqcywgY29uc3QgY2hhciAqZnVuYykKIHsKKyNpZmRlZiBOT19C
VEYKKwlyZXR1cm4gLTE7CisjZWxzZQogCXN0cnVjdCB0ZXBfYnRmICpidGYgPSB0ZXAtPmJ0
ZjsKIAlzdHJ1Y3QgYnRmX3R5cGUgKnR5cGUgPSB0ZXBfYnRmX2ZpbmRfZnVuYyhidGYsIGZ1
bmMpOwogCXN0cnVjdCBidGZfcGFyYW0gKnBhcmFtOwpAQCAtNTIwLDYgKzUyMyw3IEBAIGlu
dCB0ZXBfYnRmX2xpc3RfYXJncyhzdHJ1Y3QgdGVwX2hhbmRsZSAqdGVwLCBzdHJ1Y3QgdHJh
Y2Vfc2VxICpzLCBjb25zdCBjaGFyICpmCiAJCQl0cmFjZV9zZXFfcHJpbnRmKHMsICIlcyIs
IHBhcmFtX25hbWUpOwogCX0KIAlyZXR1cm4gcDsKKyNlbmRpZgogfQogCiAvKioKQEAgLTU0
Myw2ICs1NDcsMTAgQEAgaW50IHRlcF9idGZfbGlzdF9hcmdzKHN0cnVjdCB0ZXBfaGFuZGxl
ICp0ZXAsIHN0cnVjdCB0cmFjZV9zZXEgKnMsIGNvbnN0IGNoYXIgKmYKIGludCB0ZXBfYnRm
X3ByaW50X2FyZ3Moc3RydWN0IHRlcF9oYW5kbGUgKnRlcCwgc3RydWN0IHRyYWNlX3NlcSAq
cywgdm9pZCAqYXJncywKIAkJICAgICAgIGludCBubWVtLCBpbnQgc2l6ZSwgY29uc3QgY2hh
ciAqZnVuYykKIHsKKyNpZmRlZiBOT19CVEYKKwl0ZXBfd2FybmluZygiQlRGIG5vdCBzdXBw
b3J0ZWQuIEFyZ3M6ID8/PyBcbiIpOworCXJldHVybiAtMTsKKyNlbHNlCiAJc3RydWN0IHRl
cF9idGYgKmJ0ZiA9IHRlcC0+YnRmOwogCXN0cnVjdCBidGZfdHlwZSAqdHlwZSA9IHRlcF9i
dGZfZmluZF9mdW5jKGJ0ZiwgZnVuYyk7CiAJc3RydWN0IGJ0Zl9wYXJhbSAqcGFyYW07CkBA
IC02NDYsNCArNjU0LDUgQEAgaW50IHRlcF9idGZfcHJpbnRfYXJncyhzdHJ1Y3QgdGVwX2hh
bmRsZSAqdGVwLCBzdHJ1Y3QgdHJhY2Vfc2VxICpzLCB2b2lkICphcmdzLAogCQl9CiAJfQog
CXJldHVybiAwOworI2VuZGlmCiB9Ci0tIAoyLjQ3LjMKCg==

--------------iA6saKj2C0zdqgTDp9kwVcVT--
