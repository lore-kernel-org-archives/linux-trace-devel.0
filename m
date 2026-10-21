Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792606284;
	b=w6APywxcqaSwGHx+e4wDMFp3de//f81pi21ss8HJfrZv/2qhNJif0Bsl6D0EPY8+29QF
	 KDAhYKSf7pShdsY+N3MQR686QhHHJwuncSvxmG/TiQZ+8dHk823NJE0y0OjcI8R5Xintc
	 Gc0xS+51WpbbHhtVVFLTGrCWECZt0D/jGSnXAYiWJInV5WRz4jsEQiH/iJz7zrf74QnP4
	 +Rk7iPJ+otaJXa541r+gLQR0iptrMVzrWKQePOycINyioR7BKWzDBaanmd4cX+twh+bBU
	 QH5wGx/7uDrpeUyDzlZmar1b94s/FX5mmkWk6pUOssvezYwJn8+DogveqZmk+9A6FBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792606284;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Server:X-Rspamd-Queue-Id:X-Stat-Signature:X-Spam-Status:
	 X-Session-Marker:X-Session-ID:DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=Slaes3mB6HmGuNZccQ/viuj4L4LfDWz8+CdcXdNjCBI=;
	b=JQk4JWAGWtZsKbh3SlOwZiQ00nFNUxCjVMY8P+beYi6wdByuXR5YWDGZlRDVaitZmIfP
	 1FtcsKkAMW2GHWPHY60k9UIRpbc7vwm3YVSfvojmOmi+P3TkjnoWnGj0UcpG3vMOo4/vj
	 88Ot+ConyMn4KR9Nu6QHOyodco16Ua/IT+xBUKgZaINn2Wm24GhBGCouWKS2RxqcxOSpB
	 WDk6RK/KQZvgWzf26JTXFKaD/NMbgbhg7il60X2qZrFd5zyVfG0b+BsUrYkO3cur1Wz0W
	 oWp1mJ8IOZ8SUkkdXJ+Qo0GDq4d6KMZDSgv8nYtHZ+OKRtH97JN2PK5/kCn5Ib/2h4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=Mk3tPclF;
	arc=none smtp.remote-ip=216.40.44.15
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF51606A324
	for <linux-trace-devel@vger.kernel.org>; Wed, 21 Oct 2026 18:11:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAF51606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=Mk3tPclF
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B07E08061B;
	Wed, 21 Oct 2026 18:11:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 416B435;
	Wed, 21 Oct 2026 18:11:21 +0000 (UTC)
Date: Wed, 21 Oct 2026 14:11:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] trace-cmd: python: Update to handle python 3 functions
Message-ID: <20261021141120.62daabd1@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 416B435
X-Stat-Signature: 5b6hmhp6ro948utfpfgmiarzc9ck178s
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/QuNH9uEhn4gXqHpwVd6CxIjP2WADip34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=Slaes3mB6HmGuNZccQ/viuj4L4LfDWz8+CdcXdNjCBI=; b=Mk3tPclF8Jm5HxXpBwUNb2+rj6q/b5IRH+/ydYEKH8MYhW7TGtI0MSRuBwVX0bLuNHyiQyDn2oA4WRU33jDsFb1S7tNs8TsHWK7UwE56DXzk5OVTOaw7C/XDxOlQAtA00oJjRDmy6fHUBnEvCZzn6Z0+RZABPFLwl4S3Ad77+Y0=
X-HE-Tag: 1792606281-279401
X-HE-Meta: U2FsdGVkX1+leO9nZUC7aBwWJs72ox/Q98Ptypp9PJx1MqsDZkWSZy7vssNYALyrNkCWAduhfFj5I+cD1gobxw8ffIKtScfQTyk0p3blz73BmmDCZK2M2jyXHP9tMHLft85J9j2Ia4bNQSg+tNW/taCima0+eMAftPAz7jtj7XKYRWmFNAsIYRTUdOPmK4YSYrA+6Q+kuLPwv8mXObfv4mWHwaxIm2T7139+pHHiETuzqLPYvOnt5VOaFksIrmUc5qoibzFbc6msZ+gwENt3L/+vgJvGCFEYLjBuXcv01k+9PKtxxHFXAhqZfrYoqTde6tIAIls9dVo9isz0421OVULfbTU/nOMom4GIquPpPjO+mEYcgnH282Rv7zP7TK/B

From: Steven Rostedt <rostedt@goodmis.org>

Python 3 merged PyInt into PyLong. Add a C pre processor to change the
PyInt functions to use the PyLong ones for Python 3.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 python/ctracecmd.i | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 385646019819..52515e301f0c 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -19,6 +19,13 @@
 #include "event-parse.h"
 #include "event-utils.h"
 #include <Python.h>
+/* Compatibility macros for Python 3 */
+#if PY_VERSION_HEX >= 0x03000000
+#define PyInt_Check(x) PyLong_Check(x)
+#define PyInt_AsLong(x) PyLong_AsLong(x)
+#define PyInt_FromLong(x) PyLong_FromLong(x)
+#define PyString_Format(fmt, args)  PyUnicode_Format(fmt, args)
+#endif
 %}
 
 
-- 
2.53.0

