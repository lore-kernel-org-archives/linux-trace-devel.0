Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087019;
	b=oCTCjKMa97Ar42fBzx5Po9JUv539yIoae4m8QUnWgP1EfsQlKjHiALNsJO1p0fvACqZB
	 sWVw2Uss7vkNZfVcYdUmH5MJ0lJtXgl5IuFyLlw2CN4be8MJze8pUxfOt1FHkjIAJ99aX
	 E9AzfcfQPtk5+ySabTiVmmBJQ4RpeavcFS7lsIPGeSggDBQH8mJRuaFNe6iqQi0dxO1v+
	 SRT6Ql9s5CRyhf37EzktmEVaUae0TenFUpHxTMnGzKf8VZJgiOCC5DjrzcVcXFJVfCG30
	 Pkoye1BO2fi4QfNM6TQ4ykv9diE0kGNomby3gWOUZvB1hJKT75oU7Oa2KgmeL5KBtXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087019;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Rspamd-Server:
	 X-Stat-Signature:X-Spam-Status:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=g0JUvVWVscMAiuRuQ6Vk8GEr4mBcQucOqy/d/BaHVhc=;
	b=LUoKzLXRH26uWhHU6W49SzgPBTlWjlST2BpRUoQW9bKQaOixVgvPIlKTuCjnOk7TGJAd
	 oWNGgQuAtzB5kVoP1E4OvkJOV9RIqle7dzkGf1HuOd/+byPb8KQup6hPoJ0j3YeYisSRn
	 xDx1RytY1Ttl+nkLXIVedFlZvf1nOQCObPbGFH3BcT055vJTaaf7hRvVQs8sNYJ6Q1ziQ
	 MnX/U4+/m8Kp2AG/HostSRqjGCHGi7iFPFm4oLj3PX7FT6FH22qFEZPQrlJ8zGPdWUI/0
	 kGUyWfwZrceZ3oJkVJ5hCiqYJuX5NaccWNtwgKTCWkYdoWKSnRGaEDDm04rCZ9L3weA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=0k4Pg1Eh;
	arc=none smtp.remote-ip=216.40.44.16
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE03F606A326
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Nov 2026 21:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE03F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=0k4Pg1Eh
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9EC1C02CF;
	Sat,  7 Nov 2026 21:30:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 9239B20026;
	Sat,  7 Nov 2026 21:30:10 +0000 (UTC)
Date: Sat, 7 Nov 2026 16:29:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] Fix build failure due to btf on Linux < 6.0
Message-ID: <20261107162956.3304797b@fedora>
In-Reply-To: <20261026162417.646303-1-giulio.benetti@benettiengineering.com>
References: <20261026162417.646303-1-giulio.benetti@benettiengineering.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9239B20026
X-Rspamd-Server: rspamout08
X-Stat-Signature: odxowm4amj9pwyt1q6c6zf15ybpr6z4z
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+eaO5HwzUkXyC3AdFljCkoukW8YyGWOzY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=g0JUvVWVscMAiuRuQ6Vk8GEr4mBcQucOqy/d/BaHVhc=; b=0k4Pg1EhDhVFuNP5ukTnLV1vmbUeyWlJlFSc+8Ko7hjSC6GyVNnBqzJNHZ2q75ZitJ5ls/xA+PY5X2pkBFIgmePqHWO4XWv42eQEnvNrdH+5IzD5vJq0R3DQmcTgmIVzp+6J3NRTtTv1bsHYU5oC2kVNqA/EotBtvBtDvlozjDs=
X-HE-Tag: 1794087010-486890
X-HE-Meta: U2FsdGVkX1+vD5ZXenmfvLQWAZ/IcKcuXn6LvmP8Vap8VZ58o9ToPjN/5kdiiZaZC73iqaOO3HXMYl6qcf8wgferXcBcIdW4KH0ROAW2u8w5TR5/OP4bb3U09/diWlTDlUHUyoun3NoLTMYa9yORFj5ATgCRiGhnQSLQ57rSmJE/qXr3UTOOh2pSwv7HB/CrdDKIZwQNY444X9vqrXKbl5GfzYdCF3vjpm5ACCEBDlS3Ow+3u6newrsJg2ZVeksLYFG6Bdi55MQcMJWFKUx5JFjOnH87c+L1V/qwFBtadx9kyQYiG6FCL92Kmcr3xuCv47cMMdr+DA5j1fVNEJwjvK1miphn+7NZfnJEs9Q1NKfrwHUMwR5Kn20lcNXwx4+u5XUdCuPym+w8GglnMTyDvc9yCqB/bjKo2Q+QN02cZUT28hZf42lTyrVqcFf+aoMQ0C6QTtD0aCmnbksmB48/bQ==

On Mon, 26 Oct 2026 17:24:17 +0100
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

Hi Giulio,

Thanks for the patch.

To make it easy to know which patch is for which library in patchwork,
can you add "libtraceevent" the subject line:

  libtraceevent: Fix build failure due to btf on linux < 6.0

As I work on a repo, I filter out by the subjects and without having it
there the patch may be missed.

> With commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6089fb325cf737eeb2c4d236c94697112ca860da
> enum BTF_KIND_ENUM64 has been firstly introduced and this is the latest
> BTF_KIND_* enumaration to be added to libtraceevent. So let's check
> in runtime, both in Makefile and meson, if BTF_KIND_ENUM64 does exist
> as well as struct btf_enum64 members name_off, val_lo32, val_hi32 to
> make sure the entire enum64 facility is defined and guard for NO_BTF
> selectively in trace-btf.c.
> If it's not there let's disable btf support.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Co-authored-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
> Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
> ---
> V1->V2:
> * fixed meson check and all bft C source
> V2->V3:
> * check struct parameters other than only BTF_KIND_ENUM64
> ---
>  Makefile        | 30 +++++++++++++++++++++++-------
>  src/meson.build | 14 ++++++++++++++
>  src/trace-btf.c |  7 +++++++
>  3 files changed, 44 insertions(+), 7 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 8a7a1dd..4b291c0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -27,6 +27,13 @@ $(call allow-override,PKG_CONFIG,pkg-config)
>  $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
>  $(call allow-override,LDCONFIG,ldconfig)
>  
> +# Set compile option CFLAGS
> +ifdef EXTRA_CFLAGS
> +  CFLAGS ?= $(EXTRA_CFLAGS)
> +else
> +  CFLAGS ?= -g -Wall
> +endif
> +
>  EXT = -std=gnu99
>  INSTALL = install
>  
> @@ -37,6 +44,22 @@ INSTALL = install
>  DESTDIR ?=
>  DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
>  
> +test-build = $(if $(shell sh -c 'echo "$(1)" | tee /tmp/t.c| \
> +	$(CC) -o /dev/null -x c - > /dev/null 2>&1 && echo y'), $2)
> +
> +define BTF_LATEST_SOURCE
> +#include <linux/btf.h>
> +int main(void) { struct btf_enum64 e = {}; \
> +		 return e.name_off + e.val_lo32 + e.val_hi32 + \
> +			BTF_KIND_ENUM64; }
> +endef
> +
> +BTF_OK := $(call test-build,$(BTF_LATEST_SOURCE),y)
> +
> +ifneq ($(strip $(BTF_OK)), y)
> +CFLAGS += -DNO_BTF
> +endif
> +
>  LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
>  ifeq ($(LP64), 1)
>    libdir_relative_temp = lib64
> @@ -123,13 +146,6 @@ INCLUDES = -I. -I $(srctree)/include -I $(EP_HEADERS_DIR) $(CONFIG_INCLUDES)
>  
>  export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED EP_HEADERS_DIR
>  
> -# Set compile option CFLAGS
> -ifdef EXTRA_CFLAGS
> -  CFLAGS := $(EXTRA_CFLAGS)
> -else
> -  CFLAGS := -g -Wall
> -endif
> -
>  LIBS ?= -ldl
>  export LIBS
>  
> diff --git a/src/meson.build b/src/meson.build
> index 3a7a082..0fa5a5f 100644
> --- a/src/meson.build
> +++ b/src/meson.build
> @@ -17,6 +17,20 @@ sources= [
>  cc = meson.get_compiler('c')
>  dl_dep = cc.find_library('dl')
>  
> +btf_enum64_test_code = '''
> +#include <linux/btf.h>
> +int main(void) {
> +    struct btf_enum64 e = {};
> +
> +    return e.name_off + e.val_lo32 + e.val_hi32 +
> +           BTF_KIND_ENUM64;
> +}
> +'''
> +
> +if not cc.compiles(btf_enum64_test_code, name : 'BTF_KIND_ENUM64 check')
> +    add_project_arguments('-DNO_BTF', language : 'c')
> +endif
> +
>  libtraceevent = library(
>      'traceevent',
>      sources,
> diff --git a/src/trace-btf.c b/src/trace-btf.c
> index 2d66e01..f980d58 100644
> --- a/src/trace-btf.c
> +++ b/src/trace-btf.c
> @@ -8,7 +8,9 @@
>  #include <stdlib.h>
>  #include <stdbool.h>
>  
> +#ifndef NO_BTF
>  #include <linux/btf.h>
> +#endif

Instead of adding the #if wrapper above...

>  
>  #include "event-parse.h"
>  #include "event-utils.h"
> @@ -29,6 +31,9 @@ struct tep_btf {
>  	void			*raw_data;
>  };
>  
> +#ifdef NO_BTF
> +void btf_free(struct tep_btf *btf) {}
> +#else

Can you just move the header here?

#include <linux/btf.h>

Thanks!

-- Steve

>  #define REALLOC_SIZE (1 << 10)
>  #define REALLOC_MASK (REALLOC_SIZE - 1)
>  
> @@ -111,6 +116,7 @@ static int add_func(struct tep_btf *btf, struct btf_type *type)
>  
>  static int btf_type_size(struct btf_type *type)
>  {
> +	return -1;
>  	int kind = BTF_INFO_KIND(type->info);
>  	int size = sizeof(*type);
>  
> @@ -665,3 +671,4 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
>  	}
>  	return 0;
>  }
> +#endif

