Received: from smtpdh18-1.aruba.it (smtpdh18-1.aruba.it [62.149.155.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC8E37472E
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Mar 2026 20:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347998; cv=none; b=JUhY7StoCX5M2UwiRKn8lMmeKk0xicE0OwO8D8hzaGiRLRev9ROfgT1UvB3Aa8IuTOqX9N2omyxyitj8V51O4aR1O1X3hquec8JhnCwr4hTru3XBQfAk5QBdWE+IZdFIzgPiGQjeEffOEIiilcxmHo2FafMmw7kO6bv5rWFNXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347998; c=relaxed/simple;
	bh=8GDXogDNcxG491Qd6gYr7cqMBWiZzYGKIeaJkAdUZD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbGQ3wB9l+MtxekQlzqHooEgD7CWPcS0csVXfDaKnoNnJibP/gM/elsh2S5lD7IAo+xlp+Cx5I7O0BbzNxemWp4TLBuEZKfC4PMA4HlGByhMYSuIzlY6eu878mEwCDAVIztYItpFQVjQO2zRT8a0e5EN0ZJUygWWA/3cLh8CdcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com; spf=pass smtp.mailfrom=benettiengineering.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=HNMIx8Qt; arc=none smtp.client-ip=62.149.155.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="HNMIx8Qt"
Received: from [192.168.50.134] ([84.33.84.190])
	by Aruba SMTP with ESMTPSA
	id 0mm7wvBA15Ste0mm7w9cyN; Thu, 12 Mar 2026 21:36:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1773347816; bh=8GDXogDNcxG491Qd6gYr7cqMBWiZzYGKIeaJkAdUZD8=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=HNMIx8QtvbFlZTROlQrYK6IattmFvUuNRbihkDyx/4NG/ami6L5RUgQTV8WwiFsHJ
	 hl+NoyrMhLPFX04NPu+ZJEFXS5yeXW+yk7MjcyqX+wntRim/iFYDZbcnxHAqmrGn1P
	 SRSfc9Vv9d1ifjcHDQBw/glK9w826bqGGKZcJVX9/yauqOAR1fYUEMH9bkrZXgIJM1
	 Wq8irfV7Y7gSorAbosjIU36soUG8CpsqYSfAPmElRje1fOMK/zzpeeaMe9P6pE9JrL
	 +GRCNRnzcCC8s2fm12iVV+3TM05CC9yqrzzTpBH+G2cTHrOeNtYrUbWLXbmhLqMeFC
	 t50b4QfNPgu6A==
Message-ID: <7002d259-d8b8-452a-98dc-c5ef29f16591@benettiengineering.com>
Date: Thu, 12 Mar 2026 21:36:55 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix build failure due to btf on Linux < 6.0
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
References: <20260312195733.3034533-1-giulio.benetti@benettiengineering.com>
Content-Language: en-US
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
In-Reply-To: <20260312195733.3034533-1-giulio.benetti@benettiengineering.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKsZ0EqBKCxPJu3wDWbMZDSrpCISApNnX9KJYZisUYw/MduxMGpirsTGt8LWehRTWu015/ksW0VT+FrOTTHL9zdWWiMzjXnD9XqDFHKBDggJenOHFbMI
 Dmg5T50RuM+NiyxMs+fZa+RS/Mm8mxcXRKMspZ1QMsZVGpS0X9KG82jwxOk79sXm4wQ4Ynv/LNmElnJgO/7QAeVzYkwrypKemd/J5ldpZS1fI+fjMallw3Ob
 10cHg/x/kJ2tHwGwHevlxaQbx+zEir/9fDc2c6atfUk=

Please drop this patch that is buggy.

V2 is coming.
Sorry for the noise

Best regards
Giulio

On 12/03/2026 20:57, Giulio Benetti wrote:
> With commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6089fb325cf737eeb2c4d236c94697112ca860da
> enum BTF_KIND_ENUM64 has been firstly introduced and this is the latest
> BTF_KIND_* enumaration to be added to libtraceevent. So let's check
> in runtime, both in Makefile and meson, if BTF_KIND_ENUM64 does exist.
> If it's not there let's disable btf support.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Co-authored-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
> Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
> ---
>   Makefile        | 28 +++++++++++++++++++++-------
>   src/meson.build | 12 ++++++++++++
>   src/trace-btf.c | 10 ++++++++++
>   3 files changed, 43 insertions(+), 7 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index e1a10a0..bd88a98 100644
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
> diff --git a/src/meson.build b/src/meson.build
> index 3a7a082..23b43ff 100644
> --- a/src/meson.build
> +++ b/src/meson.build
> @@ -17,6 +17,18 @@ sources= [
>   cc = meson.get_compiler('c')
>   dl_dep = cc.find_library('dl')
>   
> +btf_enum64_test_code = '''
> +#include <linux/btf.h>
> +int main(void) {
> +    int x = BTF_KIND_ENUM64;
> +    return 0;
> +}
> +'''
> +
> +if cc.compiles(btf_enum64_test_code, name : 'BTF_KIND_ENUM64 check')
> +    add_project_arguments('-DNO_BTF', language : 'c')
> +endif
> +
>   libtraceevent = library(
>       'traceevent',
>       sources,
> diff --git a/src/trace-btf.c b/src/trace-btf.c
> index 859b086..4e3a853 100644
> --- a/src/trace-btf.c
> +++ b/src/trace-btf.c
> @@ -471,6 +471,9 @@ static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
>    */
>   int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *func)
>   {
> +#ifdef NO_BTF
> +	return -1;
> +#else
>   	struct tep_btf *btf = tep->btf;
>   	struct btf_type *type = tep_btf_find_func(btf, func);
>   	struct btf_param *param;
> @@ -520,6 +523,7 @@ int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *f
>   			trace_seq_printf(s, "%s", param_name);
>   	}
>   	return p;
> +#endif
>   }
>   
>   /**
> @@ -543,6 +547,11 @@ int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *f
>   int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
>   		       int nmem, int size, const char *func)
>   {
> +#ifdef NO_BTF
> +	tep_warning("BTF not supported. Args:\n
> +		    args: %08x, nmem: %d, size: %d, func: %08x\n");
> +	return -1;
> +#else
>   	struct tep_btf *btf = tep->btf;
>   	struct btf_type *type = tep_btf_find_func(btf, func);
>   	struct btf_param *param;
> @@ -646,4 +655,5 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
>   		}
>   	}
>   	return 0;
> +#endif
>   }

