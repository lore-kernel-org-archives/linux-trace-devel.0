Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE49286D57
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 22:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770589358; cv=none; b=AlXYJA2ZPYO2HWGi7amO7VeGK8INPEJgY56j6Ep3RdSQI2/HH0+7sokuZMwViwS+dpBVinjLfhHip0g7Uc8EnVBn8LP0wAZiw87HbvFJ/4AyjiCggiz9Y0ywLWDV4WjzcumPr5w3EPccYa0D+NIF9p7RznYLZhN515ebj7Cr2A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770589358; c=relaxed/simple;
	bh=iyumfjkREaYp92NrDk7/yuoTLDZXO/LTWtXfxbxklVs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJ8ekeFFmBSjvQtLwq9nLegWfvSDYLG8Nh8aN8JhOkgwAeMbbt4ABoEOQoGN9dgaCsgLuLldvEo/qOp3YHooBVIs40kZ62WkCkUpMdgDnUvS0Gs5fRtT5qbX4MnK/wGC054hu2a8L65WbdUXzafH+Dk2QEVqY5GvvepFJwWQaP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CD3D57397;
	Sun,  8 Feb 2026 22:22:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 9C85A1A;
	Sun,  8 Feb 2026 22:22:35 +0000 (UTC)
Date: Sun, 8 Feb 2026 17:22:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: Build failure bft for trace-cmd and libtraceevent
Message-ID: <20260208172234.3a181553@robin>
In-Reply-To: <406EA18E-BDD3-4204-A58F-B7F04450FA9F@benettiengineering.com>
References: <20260208170123.37d468a0@robin>
	<406EA18E-BDD3-4204-A58F-B7F04450FA9F@benettiengineering.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9C85A1A
X-Stat-Signature: 9g116dbtaar69r3zytirnpmg8ia3spjr
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19oLiqFegQg7JbsriQP/6AtwMMWh4sd/C8=
X-HE-Tag: 1770589355-5279
X-HE-Meta: U2FsdGVkX1/4Q04eqChMWQ0HKZW5NlI1Jo7K59x82mXX8HVJQfd7yKGMwn8a3o2rNuItIP3GR82Bkn1xtcwj+xUyAMjmCLYhBpENPiZeQT3fCQAefVKNeo13OI33OANqCrgYOFUdzm0u5EBEyBEXZN9+QFlDg1TB24R2ZXJbM6Lk7eLIXRPiTVhdUoVyK6xIccBF2VajBbWMImnXhNMx7pl0kkmlFTlbbzrww3WW9yrWZP1IISb0S6gmldxopA7sFiVVAzWFfhIMmdjH8AuYbn3UZcW8xugjxEVR2bRMF9AGTQdpptawrgdIgD0TP/yZCk+Kj0FlrSPBgj0wZMlP3wWvb5huHUY/2ctGqCXJsx2V/9CYqxKNlSKYBXJIYJkA

On Sun, 8 Feb 2026 23:14:32 +0100
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

> Oh, ok. I=E2=80=99m going to follow that commit and add btf option to dis=
able btf to trace-cmd too.
> At the moment it only checks for libtraceevent version and that won=E2=80=
=99t be sufficient.

I don't think you need to change trace-cmd. We can just make the
tep_btf_print_args() just print the arguments passed in if it is not
supported, and have the list_args just fail.

Here's an update to the libtraceevent Makefile to do this. Will need
something similar for the meson build.

-- Steve

diff --git a/Makefile b/Makefile
index e1a10a02a560..bd88a981d373 100644
--- a/Makefile
+++ b/Makefile
@@ -27,6 +27,13 @@ $(call allow-override,PKG_CONFIG,pkg-config)
 $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
 $(call allow-override,LDCONFIG,ldconfig)
=20
+# Set compile option CFLAGS
+ifdef EXTRA_CFLAGS
+  CFLAGS ?=3D $(EXTRA_CFLAGS)
+else
+  CFLAGS ?=3D -g -Wall
+endif
+
 EXT =3D -std=3Dgnu99
 INSTALL =3D install
=20
@@ -37,6 +44,20 @@ INSTALL =3D install
 DESTDIR ?=3D
 DESTDIR_SQ =3D '$(subst ','\'',$(DESTDIR))'
=20
+test-build =3D $(if $(shell sh -c 'echo "$(1)" | tee /tmp/t.c| \
+	$(CC) -o /dev/null -x c - > /dev/null 2>&1 && echo y'), $2)
+
+define BTF_LATEST_SOURCE
+#include <linux/btf.h>
+int main(void) { return BTF_KIND_ENUM64; }
+endef
+
+BTF_OK :=3D $(call test-build,$(BTF_LATEST_SOURCE),y)
+
+ifneq ($(strip $(BTF_OK)), y)
+CFLAGS +=3D -DNO_BTF
+endif
+
 LP64 :=3D $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
 ifeq ($(LP64), 1)
   libdir_relative_temp =3D lib64
@@ -123,13 +144,6 @@ INCLUDES =3D -I. -I $(srctree)/include -I $(EP_HEADERS=
_DIR) $(CONFIG_INCLUDES)
=20
 export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED EP_HEADERS_DIR
=20
-# Set compile option CFLAGS
-ifdef EXTRA_CFLAGS
-  CFLAGS :=3D $(EXTRA_CFLAGS)
-else
-  CFLAGS :=3D -g -Wall
-endif
-
 LIBS ?=3D -ldl
 export LIBS
=20
