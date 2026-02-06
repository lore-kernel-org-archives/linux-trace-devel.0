Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67853359F80
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Feb 2026 09:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770369324; cv=none; b=s1DEQkngkCocQk4X/cta4cAcvT7QU3BejN5t1xusMIwm9zvdEoajdriFoUm+DPSwF47Np5HtSq4hS7VxPC5baQJUvrW8m4CvsJaEer0VDgg1OAhHkr1N8/kuEK7d6DXv4V1I3NAOJsVtRaWga+xvuRrFuIr22G8+tti6aw2Gpqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770369324; c=relaxed/simple;
	bh=cv+6fIk3D4nHEPABl9PX+Ws19I9ZcwEjL4vKtvhyWJ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uHDASYdgHGUHShsRMNZnd3rX+LztNvXvGFl7dnSdD6RZwmWM/Ph0/jhQzIo+J+6LIm6xdkXyefvkYdZ2iov6B9ufX+9lGWtCprOEEhKL72BFYG8QVvYVx3r7bjiPOWL7t72OGdjeFnRU1GWYKjRaj+ONZvlZPyEuDR9nGrSeIVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lbd1qaJd; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lbd1qaJd"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c47ee987401so844015a12.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Feb 2026 01:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770369324; x=1770974124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XQboP24vdJLt5P7SM8mfN5cyQRPoHgRI3awZo501LdA=;
        b=Lbd1qaJd09JuC2BWj+yG26F8AgkXyMCyYV9q2AUZMZ/TIXpEVeEOuyU28JZ1iUg2f9
         bUIAUuBQLM0nXQDdZ/jfGNRsxwOkXFFBNmy9KA0WqiplfzV785Pp/39XNP5dvaSUczCk
         Ck6StekjgvCk92dnyi/xuPoIa9b3Yv1sdu8oS437w+WBJDu81NbbixgSnWGzZf1s0NE6
         2CCuUBQu/Mk2UlOiSfXndfugE6eSsmMXmqOSgqQ/mNnWC0lz3CA1UyJVjEDR7qgiBGRE
         qKrteA4LDVlhHiJ67/SBXSEKDFNKHA0jS7aqd/iF5o5z2vd8qsnPyZQxUwHE98URYLlg
         D13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770369324; x=1770974124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQboP24vdJLt5P7SM8mfN5cyQRPoHgRI3awZo501LdA=;
        b=Lpszziglng8b8VPgkKpYsA/SNb6U6SSOCi182yQdHHCtDRP/tMwoKk00duCemJuROO
         fGlOEeCv8/A2/0VbOuJrW6Wak9PaFxZ0hgDCnLWAFfmFziCJGW8ZoF1XQic6AWHI4unv
         f95CL0gvn3X4PVVyywlTjq8abRR4oyRWyOWMOUVn4Iuz5KNphkyYQV3W9OWvOSjikcS0
         SMuDtocOQhPjS2WjTvISKmACCx4lEqxegzx3m2Gi06c6W2JfN2DaGNdr059UMY4ByK1x
         H+NHxoOWU/Cv0WcZyTd6qe+VfHb4AICBe4FSKBzpQZkLBeB1qHbyLnkEfEfWq1+gMfxL
         8dog==
X-Forwarded-Encrypted: i=1; AJvYcCU1pGQeIf8TKwl+ASV6EaryEa1V+ghEWFcHzyNwi3CpB/V4tjpBorJNvWDBskDtIgdbl/uHJh//BYFMtj3pDVVaWg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0YUJEpqDAr2kAxX4c1BJTsyQ37cThnvs4U6rRfTDhwe/PzuAw
	bkqIekMEF44UUXafDRr/penwD4Dy3RtQEN+QOa6J1fSEgF09fiijJI8GXuKobYkj
X-Gm-Gg: AZuq6aJB7La9Pe6LUa+I3rS/JStV0i3o/+3r920OJWqLely2rU/P1xuVJZU4i20LKNf
	dtmkj6kHxFt5IFNd47LxZDoOflNaNHgRGl3xc3VAYJNSRxxETPrWCADPi6IMJx5uofl06+8ouQx
	VPxuuVjMpWIN38pk0z+EoKgSPeYiJKIlexmhKSVHVP7/4hcs6TFNOGEW5vIH4KEEIu4Wy4xCBlP
	ZPotuSUBlg5FxzwXQDl72WjWtc29ol6N7SEgsTq7sTPnUQxGwaKi71WrB7HAAgNIh0e2eUktOsP
	qjpUU+4brCo29ehselvJogxEpzT/4pm0gL+CiUFLYNRt9dquxhaB10ajb/oAKGKOOcygEJVBXpt
	1DrlGjG/XZr/N4eFtMtLcnNR1dj5rKnxOwmHTNs2ITNQ7MBR49BqlKG9PmiWqn30ZoWoIAJGdGQ
	l5P0RQ2OuPZCrx0Pr4a0GrNtsS28A=
X-Received: by 2002:a17:902:e888:b0:2a0:acb8:9e80 with SMTP id d9443c01a7336-2a941204016mr56262815ad.29.1770369323603;
        Fri, 06 Feb 2026 01:15:23 -0800 (PST)
Received: from pengdl-pc.mioffice.cn ([43.224.245.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521ba23asm17250665ad.49.2026.02.06.01.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 01:15:23 -0800 (PST)
From: Donglin Peng <dolinux.peng@gmail.com>
To: rostedt@goodmis.org
Cc: mhiramat@kernel.org,
	linux-trace-devel@vger.kernel.org,
	Donglin Peng <pengdonglin@xiaomi.com>
Subject: [PATCH RESEND] libtraceevent: Pretty print function parameters of enum-type
Date: Fri,  6 Feb 2026 17:15:12 +0800
Message-Id: <20260206091512.2127246-1-dolinux.peng@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Donglin Peng <pengdonglin@xiaomi.com>

The tep_btf_print_args() function currently prints values of
enum parameters in decimal format, which reduces readability.

Utilize the BTF information to resolve enum type parameters
and print their symbolic names where possible. This enhances
the trace log readability by displaying meaningful identifiers
instead of raw numbers.

Before:
mod_memcg_lruvec_state(lruvec=0xffff88800c18a540, idx=5, val=320)

After:
mod_memcg_lruvec_state(lruvec=0xffff88800c18a540, idx=5 [NR_SLAB_RECLAIMABLE_B], val=320)

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Donglin Peng <pengdonglin@xiaomi.com>
---
 src/trace-btf.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/src/trace-btf.c b/src/trace-btf.c
index 859b0860ce2a..85f5fefb4d3b 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -32,6 +32,16 @@ struct tep_btf {
 #define REALLOC_SIZE (1 << 10)
 #define REALLOC_MASK (REALLOC_SIZE - 1)
 
+#define for_each_enum(i, enum_type, member)			\
+	for (i = 0, member = btf_enum(enum_type);		\
+	     i < BTF_INFO_VLEN(enum_type->info);		\
+	     i++, member++)
+
+static inline struct btf_enum *btf_enum(const struct btf_type *t)
+{
+	return (struct btf_enum *)(t + 1);
+}
+
 static const char *btf_name(struct tep_btf *btf, int off)
 {
 	if (off < btf->hdr->str_len)
@@ -546,10 +556,11 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 	struct tep_btf *btf = tep->btf;
 	struct btf_type *type = tep_btf_find_func(btf, func);
 	struct btf_param *param;
+	struct btf_enum *enump;
 	unsigned long long arg;
 	unsigned int encode;
 	const char *param_name;
-	int a, p, x, nr;
+	int a, p, x, nr, i;
 
 	if (!func)
 		return -1;
@@ -628,6 +639,13 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 			break;
 		case BTF_KIND_ENUM:
 			trace_seq_printf(s, "%lld", arg);
+			for_each_enum(i, t, enump) {
+				if (arg == enump->val) {
+					trace_seq_printf(s, " [%s]",
+						btf_name(btf, enump->name_off));
+					break;
+				}
+			}
 			break;
 		default:
 			/* This does not handle complex arguments */
-- 
2.34.1

