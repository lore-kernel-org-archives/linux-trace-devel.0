Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794127706;
	b=U5bQGn8840hxKxilFpMsLwyVPn6CRRJP8mmZd0uNLey4LV+S0M2Hev10+DzxbMazuHII
	 EG086x9KTlZojO+hKiG2YJTB2BjzrS0/JUR3tkDNtbjHBua3k9mxBruo5bay2RMuijurM
	 RBmTZsM/3FNx7bW+m1dvzXu5qWk2AT9nAiOotzqLZPf/QPpeORXIBwMblpOBduJDNKLHX
	 2WRJ7gcpLK3AYhJjdNgbJ65A7akXZAGmww9seWe46VDxD0kOb2uw2Hqhv7xr3tRkn9JqZ
	 0l3pA+HGV/tUeuCtJcnQsdBOx8xpPPzz/8uiaY4C0TWii7mRhPBfPTZIRsIRGJxY29w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794127706;
	h=DMARC-Filter:Received:Received:Date:From:To:Subject:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Server:X-Rspamd-Queue-Id:X-Stat-Signature:X-Spam-Status:
	 X-Session-Marker:X-Session-ID:DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=zm7GMQ8aQ9/WtTyBbRmIPcjwtbX3tI2UBnbDS4M5/XQ=;
	b=FOizrQA21deMlH0pLAnyiE2XmgpbuYZjUGPnUdwqEPR2d/CvCE7C1RGRbjWDYFtV7Hd2
	 9TvikVTokhJNGnjixo1Nb4f7I+4QGVT/y6wW+JEhzReBy+tJ+V5JxNyK5clBk/I8QzwD/
	 CX8WYuyeZKgfSz2yMqc8dAOMG/5u00+fYwzeVMbGSrV2JbFC9hkaSU7uLd1basxs3aLxg
	 756l8Rm68PnLHLrCzd5h7EEUvK4RdfZTqSQVIXYG/TR5/4MX/V8W8TcLSZd4LVPuNum+v
	 NPZWe8yRkLZWToe66pQDt3fH+XviRmkomTRPB6nOO5PHBnPay07+hsY/OoBd5WUXLUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=FYmSjMML;
	arc=none smtp.remote-ip=216.40.44.11
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC11C606A31C
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 08:48:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC11C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=FYmSjMML
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 819FE120437
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 08:48:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id B248F20025
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 08:48:16 +0000 (UTC)
Date: Sun, 8 Nov 2026 03:48:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Do not discard const ename for updating it
Message-ID: <20261108034811.70c1681c@fedora>
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
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: B248F20025
X-Stat-Signature: sde7qtsxs3ops9i6ecf4xsye5fkh33po
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+44/FI4N5ML7P07prVzJq1loEQbHKXwOM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:subject:message-id:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=zm7GMQ8aQ9/WtTyBbRmIPcjwtbX3tI2UBnbDS4M5/XQ=; b=FYmSjMMLgS8C/lSekV7AbYM3u5zKLdBNEeVGBAaX5wkTetJd+U4LagTMIfltDMx/N71zrlkWQLSnZ7T5kn8Z2ItFYH4TJ3st9a0QZPQrv4DVrib0ypOwmuMsxDkWAkjH8/zpFR+bY4aFzK4Vn5Zbl5HSizQZGILjBitPGV0TDFw=
X-HE-Tag: 1794127696-19932
X-HE-Meta: U2FsdGVkX1/JzzXqUtZznBHLWf9nOhyLxwS9NJUcPmiHgPDJOSCTX96AMfHFjlrqFIkkL9weKR2uSA+/U0pgC6+8YaeNG4Hyo12lKsy6I5PalFC9dnh4/DMOU2uyeVTNBEMwvAUA44Egz6ev7vB1MmvGS6klRi24lmuN/XoCXAN20IsOGbdpQ4Ug05oJbNOHOXJdOam2TWqJukx3T7x6vaGFBdnJ7CYmHHiruqrDtbPprOeFMaC6fudSYP94c78kz+C7fAB289E4keJp31zSAl3Sb5cjW5fhxdcxfSpUPCOBWpuvU30w1HWBTGaEbvsXOuRG8+4Ni6u8Lslsw8SwX5kPc2IkPkVsNv5OVIkT7UV8jTSaZEfwwG3YuzNq1zao

From: Steven Rostedt <rostedt@goodmis.org>

The const char *ename is set as the event name that is passed into
kprobe_alloc(). If the event isn't defined, then it uses the address
instead. It creates a copy of the addr and zeros out a ':' if it exists.
Currently, this is done by pointing ename at the newly allocated addr copy
and it is modified by a temp variable. But the compiler complains that the
temp variable discards the const (which it does).

Instead of playing games with the const ename, use a new char *aname
variable to copy the addr with and do the updates. Then set ename to point
to this variable when the event name doesn't exist.

By initializing aname to NULL it can always be freed without having to
test if event is defined or not. This removes having to typecast ename to
free it too.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 src/tracefs-kprobes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 09b09d7ace04..2297d078b330 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -27,6 +27,7 @@ kprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *ev
 	struct tracefs_dynevent *kp;
 	const char *sys = system;
 	const char *ename = event;
+	char *aname = NULL;
 	char *tmp;
 
 	if (!addr) {
@@ -37,17 +38,17 @@ kprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *ev
 		sys = KPROBE_DEFAULT_GROUP;
 
 	if (!event) {
-		ename = strdup(addr);
-		if (!ename)
+		aname = strdup(addr);
+		if (!aname)
 			return NULL;
-		tmp = strchr(ename, ':');
+		tmp = strchr(aname, ':');
 		if (tmp)
 			*tmp = '\0';
+		ename = aname;
 	}
 
 	kp = tfs_dynevent_alloc(type, sys, ename, addr, format);
-	if (!event)
-		free((char *)ename);
+	free(aname);
 
 	return kp;
 }
-- 
2.53.0

